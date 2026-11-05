#requires -Version 7.0
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$templateRoot = Split-Path -Parent $PSScriptRoot
$settingsFiles = @(
    Get-ChildItem -LiteralPath (Join-Path $templateRoot 'sources') -File -Filter '*.jsonc'
    Get-ChildItem -LiteralPath (Join-Path $templateRoot 'profiles') -Recurse -File -Filter '*.json'
    Get-ChildItem -LiteralPath (Join-Path $templateRoot 'projects') -Recurse -File -Filter '*.json'
)
if (Test-Path -LiteralPath (Join-Path $templateRoot 'profiles-local')) {
    $settingsFiles += Get-ChildItem -LiteralPath (Join-Path $templateRoot 'profiles-local') -Recurse -File -Filter '*.json'
}

foreach ($file in $settingsFiles) {
    $settings = Get-Content -Raw -LiteralPath $file.FullName -Encoding utf8 |
        ConvertFrom-Json -AsHashtable -Depth 100
    if ($settings -isnot [System.Collections.IDictionary]) {
        throw "JSON object expected: $($file.FullName)"
    }
    if ($settings.Contains('latex-workshop.latex.tools')) {
        $tools = @($settings['latex-workshop.latex.tools'])
        $toolNames = @($tools | ForEach-Object { $_.name })
        if (@($toolNames | Select-Object -Unique).Count -ne $toolNames.Count) {
            throw "Duplicate LaTeX tool names: $($file.FullName)"
        }
        foreach ($recipe in $settings['latex-workshop.latex.recipes']) {
            foreach ($toolName in $recipe.tools) {
                if ($toolName -notin $toolNames) {
                    throw "Unknown LaTeX tool '$toolName': $($file.FullName)"
                }
            }
        }
        foreach ($tool in $tools) {
            if ($tool.command -eq 'texlua') {
                $projectRoot = Split-Path -Parent (Split-Path -Parent $file.FullName)
                if ($tool.args[0] -ne '%WORKSPACE_FOLDER%/scripts/build.lua' -or
                    '--engine=auto' -notin $tool.args -or
                    !(Test-Path -LiteralPath (Join-Path $projectRoot 'scripts/build.lua')) -or
                    !(Test-Path -LiteralPath (Join-Path $projectRoot 'config/latexmkrc'))) {
                    throw "Shared LaTeX builder or automatic engine selection missing: $($file.FullName)"
                }
            } elseif ('-norc' -notin $tool.args) {
                throw "Machine-independent build requires -norc: $($tool.name)"
            }
            if ('-pdf' -in $tool.args -and
                ('-lualatex' -in $tool.args -or '-xelatex' -in $tool.args)) {
                throw "Conflicting engine flags: $($tool.name)"
            }
            if ($tool.env.TEXLIVE_WINDOWS_TRY_EXTERNAL_PERL -ne '0') {
                throw "TeX Live native Perl selection missing: $($tool.name)"
            }
        }
    }
    if ($file.FullName -notmatch '[\\/]profiles-local[\\/]' -and
        (Get-Content -Raw -LiteralPath $file.FullName) -match '(?i)[A-Z]:\\\\Users\\\\') {
        throw "Personal absolute path in a portable template: $($file.FullName)"
    }
}

foreach ($profile in @('default', 'robotics')) {
    $path = Join-Path $templateRoot "profiles/$profile/settings.json"
    $settings = Get-Content -Raw -LiteralPath $path | ConvertFrom-Json -AsHashtable
    if (@($settings.Keys | Where-Object { $_ -like 'latex-workshop.*' }).Count) {
        throw "LaTeX settings found outside the school profile: $profile"
    }
}
Write-Output "Validated $($settingsFiles.Count) JSON/JSONC files, recipe references, engine flags and portable paths."
