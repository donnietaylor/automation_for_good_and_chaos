<#
.SYNOPSIS
    Emoji Chaos Bot - A chaos automation example
    Destroys code formatting using AI while keeping it functional

.DESCRIPTION
    Takes well-formatted code files and ruins them: scrambled indentation,
    useless comments, gratuitous emojis, and renamed variables — all while
    keeping the code 100% functionally identical. Supports PowerShell,
    JavaScript, and TypeScript files.

.PARAMETER Path
    File or directory to chaos-ify

.PARAMETER DryRun
    Preview the damage without applying it

.PARAMETER NoBackup
    Skip the backup (brave)

.PARAMETER Recursive
    Spread chaos to all subdirectories

.PARAMETER Restore
    Restore a file from its .bak backup

.EXAMPLE
    .\chaos-bot.ps1 -Path path\to\file.ps1
    .\chaos-bot.ps1 -Path path\to\directory -Recursive
    .\chaos-bot.ps1 -Path path\to\file.ps1 -DryRun
    .\chaos-bot.ps1 -Path path\to\file.ps1 -Restore
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,

    [switch]$DryRun,

    [switch]$NoBackup,

    [switch]$Recursive,

    [switch]$Restore
)

function Import-EnvFile {
    $envFile = Join-Path $PSScriptRoot ".env"
    if (Test-Path $envFile) {
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)\s*$') {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                if (-not [System.Environment]::GetEnvironmentVariable($name)) {
                    [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
                }
            }
        }
    }
}

Import-EnvFile

$ApiKey = $env:OPENAI_API_KEY
$Model = if ($env:OPENAI_MODEL) { $env:OPENAI_MODEL } else { "gpt-4o" }

if (-not $Restore -and -not $ApiKey) {
    Write-Error "Error: OPENAI_API_KEY not set. Create a .env file with your API key."
    exit 1
}

function Get-Language {
    param([string]$FilePath)

    $ext = [System.IO.Path]::GetExtension($FilePath).ToLower()
    $languageMap = @{
        '.ps1' = 'powershell'
        '.js'  = 'javascript'
        '.ts'  = 'typescript'
        '.jsx' = 'javascript'
        '.tsx' = 'typescript'
    }

    return $languageMap[$ext]
}

function Invoke-EmojiChaos {
    param(
        [string]$Code,
        [string]$Language
    )

    $prompt = @"
Transform this $Language code by making ONLY the six changes below. Make no other changes.

CHANGE 1 — COMMENTS (replace existing):
Replace every existing comment line with an absurd, useless, or misleading version and add 2-4 emojis.
Keep the comment character (# for PowerShell, // for JS/TS). Do not add new executable statements.
Examples:
  # Load registration data  →  # 🦄 do the thing (trust me bro) 🎲
  # Validate input          →  # 🤔 WARNING: removing this breaks everything (it won't) 💀
  # Print header            →  # 🍕🍕
  # Overall numbers         →  # 🌀 honestly who even knows

CHANGE 2 — COMMENTS (insert new):
Insert 4-8 new standalone comment lines at random points between existing lines of code.
These must be pure comment lines (starting with #) — not executable statements.
Make them absurd, existential, or emoji-only. Examples:
  # 🔥 this is fine
  # TODO: figure out what any of this does
  # do not touch this. nobody knows why it works.
  # 🐉🐉🐉

CHANGE 3 — OUTPUT STRING CONTENT:
In Write-Host, console.log, Write-Output, print(), and similar output-only calls, add emojis inside the quoted string text.
Modify only the text inside the quotes. Do not change the function name, variable names, or any other part of the line.
Example:  Write-Host 'Report complete.'  →  Write-Host '🎉 Report complete. 🦄'
Do NOT touch strings used as variable values, comparisons, hashtable keys, or non-output function arguments.

CHANGE 4 — KEYWORD AND CMDLET CASE ($Language only):
Randomly vary the capitalization of keywords and built-in cmdlet/function names. The language runtime is case-insensitive for these.
For PowerShell: vary case on keywords (if, else, foreach, return, function, param, while, for, switch, try, catch) and cmdlet names (Write-Host, Get-Content, Sort-Object, etc.)
For JavaScript/TypeScript: vary case on keywords (if, else, for, return, function, const, let, var, while, switch, try, catch)
Examples: `if` → `IF` or `If`, `foreach` → `FOREACH` or `ForEach`, `Write-Host` → `WRITE-HOST` or `write-host`
Do NOT change variable names or property names — only keywords and built-in cmdlet/function names.

CHANGE 5 — HASHTABLE / OBJECT KEY ORDER:
Shuffle the order of key-value pairs inside object/hashtable literals (@{} in PowerShell, {} object literals in JS/TS).
Keep every key and its value — only the order changes. Order does not affect behavior.

CHANGE 6 — INDENTATION AND BLANK LINES:
Change leading whitespace on lines: add extra spaces, remove spaces, mix tabs and spaces inconsistently.
Insert 1-2 extra blank lines at a few random locations.
Do NOT change any character after the first non-whitespace character on any line.

ABSOLUTE PROHIBITIONS — any of these will produce broken, unrunnable code:
- Do NOT add, move, remove, or reorder any executable code statements
- Do NOT rename any variables, parameters, or functions
- Do NOT add or remove any brackets {}, parentheses (), or square brackets []
- Do NOT add semicolons anywhere
- Do NOT modify param() blocks in any way except leading whitespace
- Do NOT split a single-line statement across multiple lines
- Do NOT merge multiple statements onto one line
- Do NOT change strings that are not inside a direct output call
- Do NOT add any text that is not a comment or whitespace change between existing statements

Return ONLY the transformed code with no explanation and no markdown fences.

Code to transform:
``````$Language
$Code
``````
"@

    $body = @{
        model    = $Model
        messages = @(
            @{
                role    = "system"
                content = "You transform code by modifying comments, output strings, keyword casing, hashtable key order, indentation, and blank lines only. You never change logic, add executable statements, rename variables, or alter punctuation. Return only raw code with no markdown and no explanation."
            },
            @{
                role    = "user"
                content = $prompt
            }
        )
        temperature = 0.9
    } | ConvertTo-Json -Depth 10

    try {
        $response = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" `
            -Method Post `
            -Headers @{
                "Authorization" = "Bearer $ApiKey"
                "Content-Type"  = "application/json"
            } `
            -Body $body

        $chaotic = $response.choices[0].message.content.Trim()

        # Strip markdown fences if the model added them anyway
        if ($chaotic -match '^```') {
            $lines = $chaotic -split "`n"
            $chaotic = ($lines[1..($lines.Length - 2)]) -join "`n"
        }

        return $chaotic
    }
    catch {
        Write-Warning "Error calling OpenAI API: $_"
        return $Code
    }
}

function Show-Diff {
    param(
        [string]$Original,
        [string]$Chaotic,
        [string]$FileName
    )

    $originalLines = $Original -split "`n"
    $chaoticLines  = $Chaotic -split "`n"

    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Damage preview for ${FileName}:" -ForegroundColor Magenta
    Write-Host ("=" * 60)

    $maxLines = [Math]::Max($originalLines.Count, $chaoticLines.Count)
    for ($i = 0; $i -lt $maxLines; $i++) {
        $orig = if ($i -lt $originalLines.Count) { $originalLines[$i] } else { $null }
        $chao = if ($i -lt $chaoticLines.Count)  { $chaoticLines[$i]  } else { $null }

        if ($orig -ne $chao) {
            if ($null -ne $orig) { Write-Host "- $orig" -ForegroundColor Green }
            if ($null -ne $chao) { Write-Host "+ $chao" -ForegroundColor Red   }
        }
    }

    Write-Host ("=" * 60)
    Write-Host ""
}

function Restore-ChaoticFile {
    param([string]$FilePath)

    $backupPath = "$FilePath.bak"
    if (-not (Test-Path $backupPath)) {
        Write-Warning "No backup found: $backupPath"
        return $false
    }

    Copy-Item -Path $backupPath -Destination $FilePath -Force
    Remove-Item -Path $backupPath
    Write-Host "✓ Restored $FilePath" -ForegroundColor Green
    return $true
}

function Invoke-ChaoticFile {
    param(
        [string]$FilePath,
        [bool]$DryRun = $false,
        [bool]$Backup = $true
    )

    if (-not (Test-Path $FilePath)) {
        Write-Warning "File not found: $FilePath"
        return $false
    }

    $language = Get-Language -FilePath $FilePath
    if (-not $language) {
        Write-Host "Skipping unsupported file type: $FilePath"
        return $false
    }

    Write-Host "Processing $FilePath..."

    $originalCode = Get-Content -Path $FilePath -Raw -Encoding UTF8

    # For PowerShell files, validate output with the PS parser and retry once on failure
    $chaoticCode = $null
    $maxAttempts = if ($language -eq 'powershell') { 2 } else { 1 }
    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        $candidate = Invoke-EmojiChaos -Code $originalCode -Language $language

        if ($language -eq 'powershell') {
            $parseErrors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseInput(
                $candidate, [ref]$null, [ref]$parseErrors
            )
            if ($parseErrors.Count -gt 0) {
                if ($attempt -lt $maxAttempts) {
                    Write-Warning "Attempt $attempt produced invalid syntax — retrying..."
                    continue
                }
                Write-Warning "Chaos output failed syntax validation after $maxAttempts attempt(s):"
                foreach ($err in $parseErrors) {
                    Write-Warning ("  Line {0}: {1}" -f $err.Extent.StartLineNumber, $err.Message)
                }
                Write-Warning "Re-run the bot to try again."
                return $false
            }
        }

        $chaoticCode = $candidate
        break
    }

    if ($originalCode.Trim() -eq $chaoticCode.Trim()) {
        Write-Host "Already chaotic enough. Nothing to do."
        return $true
    }

    Show-Diff -Original $originalCode -Chaotic $chaoticCode -FileName (Split-Path $FilePath -Leaf)

    if ($DryRun) {
        Write-Host "Dry run - no damage applied."
        return $true
    }

    $confirm = Read-Host "Apply this chaos? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Chaos averted."
        return $false
    }

    if ($Backup) {
        $backupPath = "$FilePath.bak"
        Copy-Item -Path $FilePath -Destination $backupPath
        Write-Host "Backup created: $backupPath"
    }

    Set-Content -Path $FilePath -Value $chaoticCode -Encoding UTF8 -NoNewline
    Write-Host "🎉 Chaos applied to $FilePath" -ForegroundColor Red
    return $true
}

# Main logic
$resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
if (-not $resolvedPath) {
    Write-Error "Path not found: $Path"
    exit 1
}

$item = Get-Item $resolvedPath

if ($Restore) {
    if ($item.PSIsContainer) {
        Write-Error "Restore requires a file path, not a directory."
        exit 1
    }
    Restore-ChaoticFile -FilePath $item.FullName
}
elseif ($item.PSIsContainer) {
    $files = Get-ChildItem -Path $resolvedPath -File -Recurse:$Recursive |
        Where-Object { Get-Language -FilePath $_.FullName }

    Write-Host "Found $($files.Count) files to chaos-ify"

    foreach ($file in $files) {
        Invoke-ChaoticFile -FilePath $file.FullName -DryRun $DryRun.IsPresent -Backup (-not $NoBackup.IsPresent)
    }
}
else {
    Invoke-ChaoticFile -FilePath $item.FullName -DryRun $DryRun.IsPresent -Backup (-not $NoBackup.IsPresent)
}
