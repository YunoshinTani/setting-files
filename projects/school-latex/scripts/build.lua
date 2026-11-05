#!/usr/bin/env texlua
-- Shared entry point for VS Code, command-line helpers and CI. TeX Live includes texlua.
local lfs = require('lfs')

local function fail(message)
  io.stderr:write('LaTeX: ' .. message .. '\n')
  os.exit(2)
end

local function absolute(path)
  path = path:gsub('\\', '/')
  if path:sub(1, 1) ~= '/' and not path:match('^%a:/') then
    path = lfs.currentdir():gsub('\\', '/') .. '/' .. path
  end
  return path
end

local function is_file(path)
  return lfs.attributes(path, 'mode') == 'file'
end

local engines = {uplatex = true, platex = true, lualatex = true, pdflatex = true, xelatex = true}
local root_file, requested_engine
local clean = false
for _, value in ipairs(arg) do
  if value == '--clean' then
    clean = true
  elseif value:match('^%-%-engine=') then
    if requested_engine then fail('Specify the engine only once.') end
    requested_engine = value:sub(10):lower()
    if requested_engine ~= 'auto' and not engines[requested_engine] then
      fail('Choose uplatex, platex, lualatex, pdflatex or xelatex for --engine.')
    end
  elseif value == '--help' or value == '-h' then
    print('Usage: texlua scripts/build.lua [--clean] [--engine=auto|uplatex|platex|lualatex|pdflatex|xelatex] ROOT.tex')
    os.exit(0)
  elseif value:sub(1, 1) == '-' then
    fail('Unknown option: ' .. value)
  elseif root_file then
    fail('Specify only one root TeX file.')
  else
    root_file = value
  end
end
if not root_file then fail('Specify a root TeX file. Use --help for the command format.') end
root_file = absolute(root_file)
if not root_file:lower():match('%.tex$') or not is_file(root_file) then
  fail('TeX file not found: ' .. root_file)
end

local project_dir = root_file:match('^(.*)/[^/]+$')
local local_rc = project_dir .. '/.latexmkrc'
local script_dir = absolute(arg[0]):match('^(.*)/[^/]+$')
local shared_rc = script_dir .. '/../config/latexmkrc'
local has_local_rc = is_file(local_rc)
local rc = has_local_rc and local_rc or shared_rc
if not is_file(rc) then
  fail('Shared build settings are missing. Keep scripts/ and config/ together in the downloaded folder.')
end

-- Only an allowlisted engine name is read from the header. No comment is run as a command.
local function header_engine()
  local file, message = io.open(root_file, 'rb')
  if not file then fail(message) end
  local selected
  for line in file:lines() do
    line = line:gsub('^\239\187\191', '') -- UTF-8 BOM
    if line:match('^%s*[^%%%s]') then break end
    local value = line:lower():match('^%s*%%%s*!%s*tex%s+program%s*=%s*(.-)%s*$')
      or line:lower():match('^%s*%%%s*!%s*tex%s+ts%-program%s*=%s*(.-)%s*$')
    if value then
      -- TeXworks uses these labels in common Japanese school templates.
      if value:match('^uplatex%s*%(ptex2pdf%)$') then value = 'uplatex' end
      if value:match('^platex%s*%(ptex2pdf%)$') then value = 'platex' end
      if not engines[value] then
        file:close()
        fail('Unsupported TeX program. Use a header such as: % !TeX program = uplatex')
      end
      if selected and selected ~= value then
        file:close()
        fail('Conflicting TeX program headers. Keep only one engine declaration.')
      end
      selected = value
    end
  end
  file:close()
  return selected
end

-- auto makes VS Code independent of a user's permanent LATEX_ENGINE environment variable.
local engine = requested_engine
if engine == 'auto' then
  engine = nil
elseif not engine then
  engine = os.getenv('LATEX_ENGINE')
  if engine == '' then engine = nil end
end
if engine and not engines[engine] then
  fail('Unsupported LATEX_ENGINE. Choose uplatex, platex, lualatex, pdflatex or xelatex.')
end
if not has_local_rc and not engine then engine = header_engine() or 'uplatex' end
os.setenv('LATEX_ENGINE', engine or '')
os.setenv('TEXLIVE_WINDOWS_TRY_EXTERNAL_PERL', '0')

local command = {'latexmk', '-norc', '-r', rc, '-cd', '-outdir=' .. project_dir .. '/export'}
if clean then command[#command + 1] = '-c' end
command[#command + 1] = root_file

-- os.spawn uses an argument vector, without a shell. The Windows C runtime needs
-- explicit quoting for each argument to preserve spaces (as in TeX Live's rungs.lua).
if os.type == 'windows' then
  local quoted = {[0] = command[1]}
  for index, value in ipairs(command) do
    quoted[index] = '"' .. value:gsub('(\\*)"', '%1%1\\"'):gsub('(\\+)$', '%1%1') .. '"'
  end
  command = quoted
end
print('LaTeX: ' .. (clean and 'clean' or 'build') .. ' (' .. (has_local_rc and 'local .latexmkrc' or engine) .. ')')
io.stdout:flush()
local status, message = os.spawn(command)
if not status then
  fail('Cannot start latexmk. Install TeX Live with latexmk and make it available in PATH. ' .. tostring(message))
end
os.exit(status)
