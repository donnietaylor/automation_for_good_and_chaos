<#
.SYNOPSIS
    MMS MOA 2026 — Session Registration Report
    Self-contained summary of conference session registrations and attendance
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Format-PercentBar {
    <#
    .SYNOPSIS
        Returns an ASCII progress bar representing a fraction of a total
    #>
    param(
        [int]$Value,
        [int]$Total,
        [int]$Width = 24
    )

    if ($Total -eq 0) { return "[------------------------] 0 / 0" }
    $filled = [math]::Min([math]::Round(($Value / $Total) * $Width), $Width)
    $bar    = ('#' * $filled) + ('-' * ($Width - $filled))
    return "[$bar] $Value / $Total"
}

function Get-SessionSummary {
    <#
    .SYNOPSIS
        Aggregates session data into totals, track counts, and top sessions
    #>
    param([object[]]$Sessions)

    $byTrack    = @{}
    $overCap    = @()

    foreach ($session in $Sessions) {
        $track = $session.Track
        if (-not $byTrack.ContainsKey($track)) {
            $byTrack[$track] = @{ Registered = 0; Capacity = 0; Sessions = 0 }
        }
        $byTrack[$track].Registered += $session.Registered
        $byTrack[$track].Capacity   += $session.Capacity
        $byTrack[$track].Sessions++

        if ($session.Registered -gt $session.Capacity) {
            $overCap += $session
        }
    }

    return @{
        TotalSessions    = $Sessions.Count
        TotalRegistered  = ($Sessions | Measure-Object -Property Registered -Sum).Sum
        TotalCapacity    = ($Sessions | Measure-Object -Property Capacity   -Sum).Sum
        ByTrack          = $byTrack
        OverCapacity     = $overCap
        TopSessions      = $Sessions | Sort-Object Registered -Descending | Select-Object -First 5
    }
}

# Session data — MMS MOA 2026
$sessions = @(
    [pscustomobject]@{ Title = 'Opening Keynote: AI Is Eating IT and We Have Feelings About It'; Track = 'Community';           Day = 1; Room = 'Main Hall';  Capacity = 600; Registered = 587 }
    [pscustomobject]@{ Title = 'Intune From Zero to Production in 90 Days';                      Track = 'Endpoint Mgmt';       Day = 1; Room = 'Ballroom A'; Capacity = 200; Registered = 214 }
    [pscustomobject]@{ Title = 'Copilot Prompting: Less Vibes, More Repro Steps';               Track = 'AI + Automation';     Day = 1; Room = 'Ballroom B'; Capacity = 200; Registered = 198 }
    [pscustomobject]@{ Title = 'Zero Trust in Practice: Why Your VPN Is Still Running';          Track = 'Security';            Day = 1; Room = 'Ballroom C'; Capacity = 200; Registered = 176 }
    [pscustomobject]@{ Title = 'PowerShell for People Who Said They Would Learn It Last Year';   Track = 'AI + Automation';     Day = 1; Room = 'Breakout 1'; Capacity = 120; Registered = 143 }
    [pscustomobject]@{ Title = 'Azure Cost Management Without the Existential Dread';            Track = 'Azure + Cloud';       Day = 1; Room = 'Breakout 2'; Capacity = 120; Registered = 97  }
    [pscustomobject]@{ Title = 'Entra ID Deep Dive: Conditional Access That Actually Scales';    Track = 'Security';            Day = 1; Room = 'Breakout 3'; Capacity = 120; Registered = 118 }
    [pscustomobject]@{ Title = 'Day 1 Happy Hour — Automation for Good and Chaos';              Track = 'Community';           Day = 1; Room = 'Expo Hall';  Capacity = 400; Registered = 391 }

    [pscustomobject]@{ Title = 'Windows Autopilot: The Honest Talk';                            Track = 'Endpoint Mgmt';       Day = 2; Room = 'Ballroom A'; Capacity = 200; Registered = 189 }
    [pscustomobject]@{ Title = 'Building Agentic Workflows Without Breaking Production';         Track = 'AI + Automation';     Day = 2; Room = 'Ballroom B'; Capacity = 200; Registered = 221 }
    [pscustomobject]@{ Title = 'RBAC at Scale: Why Is My Access Denied in 14 Different Ways';   Track = 'Security';            Day = 2; Room = 'Ballroom C'; Capacity = 200; Registered = 162 }
    [pscustomobject]@{ Title = 'Microsoft 365 Governance Without Sadness';                      Track = 'Microsoft 365';       Day = 2; Room = 'Breakout 1'; Capacity = 120; Registered = 104 }
    [pscustomobject]@{ Title = 'AVD and Windows 365: Pick One and Commit';                      Track = 'Azure + Cloud';       Day = 2; Room = 'Breakout 2'; Capacity = 120; Registered = 88  }
    [pscustomobject]@{ Title = 'MEM/SCCM Co-Management: The Migration You Keep Postponing';     Track = 'Endpoint Mgmt';       Day = 2; Room = 'Breakout 3'; Capacity = 120; Registered = 131 }
    [pscustomobject]@{ Title = 'Community Lunch and Birds-of-a-Feather Tables';                 Track = 'Community';           Day = 2; Room = 'Expo Hall';  Capacity = 500; Registered = 468 }

    [pscustomobject]@{ Title = 'Defender for Endpoint: What the Alerts Are Actually Telling You'; Track = 'Security';          Day = 3; Room = 'Ballroom A'; Capacity = 200; Registered = 155 }
    [pscustomobject]@{ Title = 'n8n and Power Automate: When to Use Which';                     Track = 'AI + Automation';     Day = 3; Room = 'Ballroom B'; Capacity = 200; Registered = 167 }
    [pscustomobject]@{ Title = 'SharePoint Premium and the Purview Sprawl Problem';             Track = 'Microsoft 365';       Day = 3; Room = 'Ballroom C'; Capacity = 200; Registered = 93  }
    [pscustomobject]@{ Title = 'Terraform for the ConfigMgr Admin';                             Track = 'Azure + Cloud';       Day = 3; Room = 'Breakout 1'; Capacity = 120; Registered = 76  }
    [pscustomobject]@{ Title = 'Closing Panel: Did We Just Automate the Entire IT Department';  Track = 'Community';           Day = 3; Room = 'Main Hall';  Capacity = 600; Registered = 542 }
)

$summary = Get-SessionSummary -Sessions $sessions

# Print header
Write-Host ''
Write-Host ('=' * 58)
Write-Host '  MMS MOA 2026 — Session Registration Report'
Write-Host ('=' * 58)
Write-Host ''

# Overall numbers
$fillRate = [math]::Round(($summary.TotalRegistered / $summary.TotalCapacity) * 100)
Write-Host ("  Sessions    : {0}"     -f $summary.TotalSessions)
Write-Host ("  Registered  : {0}"     -f $summary.TotalRegistered)
Write-Host ("  Capacity    : {0}"     -f $summary.TotalCapacity)
Write-Host ("  Fill rate   : {0}%"    -f $fillRate)
Write-Host ''

# Over-capacity sessions
if ($summary.OverCapacity.Count -gt 0) {
    Write-Host '  OVER CAPACITY — waitlist expected:' -ForegroundColor Yellow
    foreach ($s in $summary.OverCapacity) {
        $overflow = $s.Registered - $s.Capacity
        Write-Host ("    + {0} (+{1})" -f $s.Title, $overflow) -ForegroundColor Yellow
    }
    Write-Host ''
}

# Top 5 sessions
Write-Host '  TOP SESSIONS BY REGISTRATION:'
foreach ($s in $summary.TopSessions) {
    Write-Host ("    {0}" -f (Format-PercentBar -Value $s.Registered -Total $s.Capacity))
    Write-Host ("    {0}" -f $s.Title)
    Write-Host ''
}

# By track
Write-Host '  BY TRACK:'
foreach ($track in ($summary.ByTrack.Keys | Sort-Object)) {
    $t = $summary.ByTrack[$track]
    Write-Host ("    {0,-22} {1}" -f ($track + ':'), (Format-PercentBar -Value $t.Registered -Total $t.Capacity))
}

Write-Host ''
Write-Host ('=' * 58)
Write-Host '  Report complete. See you in the hallway track.'
Write-Host ('=' * 58)
Write-Host ''
