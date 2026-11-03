#requires -Version 7.0
[CmdletBinding()]
param([switch] $IncludeMachine)

$ErrorActionPreference = 'Stop'
$templateRoot = Split-Path -Parent $PSScriptRoot

function Read-Settings([string] $Path) {
    $settings = Get-Content -Raw -LiteralPath $Path -Encoding utf8 |
        ConvertFrom-Json -AsHashtable -Depth 100
    if ($settings -isnot [System.Collections.IDictionary]) {
        throw "Settings must be a JSON object: $Path"
    }
    return $settings
}

function Merge-Settings(
    [System.Collections.IDictionary] $Base,
    [System.Collections.IDictionary] $Override
) {
    # Merge objects recursively; replace scalars and entire arrays.
    $merged = [ordered]@{}
    foreach ($key in $Base.Keys) { $merged[$key] = $Base[$key] }
    foreach ($key in $Override.Keys) {
        if ($merged.Contains($key) -and
            $merged[$key] -is [System.Collections.IDictionary] -and
            $Override[$key] -is [System.Collections.IDictionary]) {
            $merged[$key] = Merge-Settings $merged[$key] $Override[$key]
        } else {
            $merged[$key] = $Override[$key]
        }
    }
    return $merged
}

$commonSettings = Read-Settings (Join-Path $templateRoot 'sources/common.settings.jsonc')
$generatedFiles = [ordered]@{}
foreach ($profileName in @('default', 'school', 'robotics')) {
    $overrides = Read-Settings (Join-Path $templateRoot "sources/$profileName.overrides.jsonc")
    $settings = Merge-Settings $commonSettings $overrides
    $localPath = Join-Path $templateRoot "machine/$profileName.local.jsonc"
    if ($IncludeMachine -and (Test-Path -LiteralPath $localPath)) {
        $settings = Merge-Settings $settings (Read-Settings $localPath)
    }
    if ($profileName -ne 'school' -and
        @($settings.Keys | Where-Object { $_ -like 'latex-workshop.*' }).Count -ne 0) {
        throw "LaTeX Workshop settings must be kept in the school profile: $profileName"
    }
    $sourcePaths = "sources/common.settings.jsonc + sources/$profileName.overrides.jsonc"
    if ($IncludeMachine -and (Test-Path -LiteralPath $localPath)) {
        $sourcePaths += " + machine/$profileName.local.jsonc"
    }
    $buildOptions = if ($IncludeMachine) { ' -IncludeMachine' } else { '' }
    $header = "// 生成元: $sourcePaths`n"
    $header += "// 編集は生成元へ。再生成: ./scripts/Build-Profiles.ps1$buildOptions`n"
    $json = ($settings | ConvertTo-Json -Depth 100).Replace("`r`n", "`n")
    $generatedFiles[$profileName] = $header + $json + "`n"
}

# All inputs are parsed before writing. This only updates generated templates,
# never the active VS Code profiles or existing projects.
foreach ($profileName in $generatedFiles.Keys) {
    $outputFolder = if ($IncludeMachine) { 'profiles-local' } else { 'profiles' }
    $outputDirectory = Join-Path $templateRoot "$outputFolder/$profileName"
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    $outputPath = Join-Path $outputDirectory 'settings.json'
    $contents = $generatedFiles[$profileName]
    if (!(Test-Path -LiteralPath $outputPath) -or
        [IO.File]::ReadAllText($outputPath) -cne $contents) {
        [IO.File]::WriteAllText($outputPath, $contents, [Text.UTF8Encoding]::new($false))
    }
    Write-Output "Generated $outputFolder/$profileName/settings.json"
}
