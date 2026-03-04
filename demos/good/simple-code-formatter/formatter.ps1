<#
.SYNOPSIS
    Simple Code Formatter - A good automation example
    Formats code files using AI assistance

.DESCRIPTION
    Formats code files using the OpenAI API according to best practices.
    Supports Python, JavaScript, and TypeScript files.

.PARAMETER Path
    File or directory to format

.PARAMETER DryRun
    Preview changes without applying them

.PARAMETER NoBackup
    Don't create backup files before modifying

.PARAMETER Recursive
    Process directories recursively

.EXAMPLE
    .\formatter.ps1 -Path path\to\file.py
    .\formatter.ps1 -Path path\to\directory -Recursive
    .\formatter.ps1 -Path path\to\file.py -DryRun
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,

    [switch]$DryRun,

    [switch]$NoBackup,

    [switch]$Recursive
)

# Load environment variables from .env file
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
$Model = if ($env:OPENAI_MODEL) { $env:OPENAI_MODEL } else { "gpt-3.5-turbo" }

if (-not $ApiKey) {
    Write-Error "Error: OPENAI_API_KEY not set. Create a .env file with your API key."
    exit 1
}

function Get-Language {
    <#
    .SYNOPSIS
        Determine programming language from file extension
    #>
    param([string]$FilePath)

    $ext = [System.IO.Path]::GetExtension($FilePath).ToLower()
    $languageMap = @{
        '.py'  = 'python'
        '.js'  = 'javascript'
        '.ts'  = 'typescript'
        '.jsx' = 'javascript'
        '.tsx' = 'typescript'
    }

    return $languageMap[$ext]
}

function Format-CodeWithAI {
    <#
    .SYNOPSIS
        Format code using OpenAI API

    .PARAMETER Code
        Source code to format

    .PARAMETER Language
        Programming language (python, javascript, typescript)

    .OUTPUTS
        Formatted code string
    #>
    param(
        [string]$Code,
        [string]$Language
    )

    $prompt = @"
Format this $Language code according to best practices:
- Use consistent indentation
- Add type hints (if applicable)
- Use meaningful variable names
- Add docstrings to functions
- Follow language-specific style guides (PEP 8 for Python, etc.)
- Preserve all functionality

Return ONLY the formatted code, no explanations.

Code:
``````$Language
$Code
``````
"@

    $body = @{
        model    = $Model
        messages = @(
            @{
                role    = "system"
                content = "You are an expert code formatter. Return only formatted code without explanations or markdown."
            },
            @{
                role    = "user"
                content = $prompt
            }
        )
        temperature = 0.3
    } | ConvertTo-Json -Depth 10

    try {
        $response = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" `
            -Method Post `
            -Headers @{
                "Authorization" = "Bearer $ApiKey"
                "Content-Type"  = "application/json"
            } `
            -Body $body

        $formatted = $response.choices[0].message.content.Trim()

        # Remove markdown code blocks if present
        if ($formatted -match '^```') {
            $lines = $formatted -split "`n"
            $formatted = ($lines[1..($lines.Length - 2)]) -join "`n"
        }

        return $formatted
    }
    catch {
        Write-Warning "Error calling OpenAI API: $_"
        return $Code
    }
}

function Show-Diff {
    <#
    .SYNOPSIS
        Show a simple diff between original and formatted code
    #>
    param(
        [string]$Original,
        [string]$Formatted,
        [string]$FileName
    )

    $originalLines = $Original -split "`n"
    $formattedLines = $Formatted -split "`n"

    Write-Host ""
    Write-Host ("=" * 60)
    Write-Host "Changes for ${FileName}:"
    Write-Host ("=" * 60)

    $maxLines = [Math]::Max($originalLines.Count, $formattedLines.Count)
    for ($i = 0; $i -lt $maxLines; $i++) {
        $orig = if ($i -lt $originalLines.Count) { $originalLines[$i] } else { $null }
        $fmt  = if ($i -lt $formattedLines.Count) { $formattedLines[$i] } else { $null }

        if ($orig -ne $fmt) {
            if ($null -ne $orig) {
                Write-Host "- $orig" -ForegroundColor Red
            }
            if ($null -ne $fmt) {
                Write-Host "+ $fmt" -ForegroundColor Green
            }
        }
    }

    Write-Host ("=" * 60)
    Write-Host ""
}

function Format-File {
    <#
    .SYNOPSIS
        Format a single code file

    .PARAMETER FilePath
        Path to the file to format

    .PARAMETER DryRun
        If true, only show changes without applying

    .PARAMETER Backup
        If true, create a backup before modifying
    #>
    param(
        [string]$FilePath,
        [bool]$DryRun = $false,
        [bool]$Backup = $true
    )

    if (-not (Test-Path $FilePath)) {
        Write-Warning "Error: File not found: $FilePath"
        return $false
    }

    $language = Get-Language -FilePath $FilePath
    if (-not $language) {
        Write-Host "Skipping unsupported file type: $FilePath"
        return $false
    }

    Write-Host "Processing $FilePath..."

    $originalCode = Get-Content -Path $FilePath -Raw -Encoding UTF8
    $formattedCode = Format-CodeWithAI -Code $originalCode -Language $language

    if ($originalCode.Trim() -eq $formattedCode.Trim()) {
        Write-Host "No changes needed."
        return $true
    }

    Show-Diff -Original $originalCode -Formatted $formattedCode -FileName (Split-Path $FilePath -Leaf)

    if ($DryRun) {
        Write-Host "Dry run - no changes applied."
        return $true
    }

    $confirm = Read-Host "Apply these changes? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Changes discarded."
        return $false
    }

    if ($Backup) {
        $backupPath = "$FilePath.bak"
        Copy-Item -Path $FilePath -Destination $backupPath
        Write-Host "Backup created: $backupPath"
    }

    Set-Content -Path $FilePath -Value $formattedCode -Encoding UTF8 -NoNewline
    Write-Host "✓ Successfully formatted $FilePath" -ForegroundColor Green
    return $true
}

# Main logic
$resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
if (-not $resolvedPath) {
    Write-Error "Error: Path not found: $Path"
    exit 1
}

$item = Get-Item $resolvedPath

if ($item.PSIsContainer) {
    $files = Get-ChildItem -Path $resolvedPath -File -Recurse:$Recursive |
        Where-Object { Get-Language -FilePath $_.FullName }

    Write-Host "Found $($files.Count) files to process"

    foreach ($file in $files) {
        Format-File -FilePath $file.FullName -DryRun $DryRun.IsPresent -Backup (-not $NoBackup.IsPresent)
    }
}
else {
    Format-File -FilePath $item.FullName -DryRun $DryRun.IsPresent -Backup (-not $NoBackup.IsPresent)
}
