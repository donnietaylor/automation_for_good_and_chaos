param([int]$Day=2,[switch]$IncludeChaos,[int]$Seed=2026)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function new_attendee($n,$r,$cups,$topic){
 $o=[pscustomobject]@{name=$n;role=$r;coffee=$cups;topic=$topic;checkedIn=$false;lanyard='';swag=@();note=''}
            if($r -eq 'speaker'){$o.lanyard='gold'}elseif($r -eq 'volunteer'){$o.lanyard='green'}elseif($r -eq 'sponsor'){$o.lanyard='platinum-ish'}else{$o.lanyard='blue'}
    if($cups -le 0){$o.note='running on hope and expo-hall cookies'}
                return $o
}

function new_session($time,$title,$track,$room,$speaker){
[pscustomobject]@{time=$time;title=$title;track=$track;room=$room;speaker=$speaker;capacity=50;registered=0;waitlist=0;tags=@()}
}

function get_coffee_state($cups){if($cups -lt 1){'critical'}elseif($cups -lt 3){'functional'}elseif($cups -lt 5){'keynote-ready'}else{'unstoppable and making architecture diagrams on napkins'}}

function invoke_buzzword_scan($line){
 $words='synergy','agentic','governance','copilot','prompt','zero trust','roadmap','enterprise-ready'
 $hits=0
 foreach($w in $words){if($line.ToLower().Contains($w.ToLower())){$hits++}}
 if($hits -ge 5){return "BINGO:$hits"}
            if($hits -ge 2){return "Dense:$hits"}
 return "Light:$hits"
}

function get_swag($person,[switch]$chaosMode){
	$bag=@('sticker pack','lanyard clip','tiny notebook')
if($person.role -eq 'speaker'){ $bag += 'mystery HDMI dongle';$bag += 'cold brew voucher'}
                if($person.role -eq 'volunteer'){$bag+='thank-you pin'}
if($person.coffee -gt 3){$bag+='decaf intervention coupon'}
 if($chaosMode){$bag+='rubber duck marked INCIDENT COMMANDER'}
 return $bag
}

$null=Get-Random -SetSeed $Seed
$conference='MMS MOA 2026';   $city='Dallas';$venue='Big Room With The Better Wi-Fi (Allegedly)'
$wifi='MMS-MOA-Guest';$helpDesk='Table by the giant banner';

$attendees=@(
(new_attendee 'Avery' 'speaker' 4 'AI + Automation') ,(new_attendee 'Jordan' 'attendee' 1 'Security') ,
(new_attendee 'Priya' 'volunteer' 2 'Community Ops') ,(new_attendee 'Sam' 'sponsor' 3 'Cloud Cost Stories') ,
	(new_attendee 'Taylor' 'attendee' 0 'Prompt Hygiene') ,(new_attendee 'Morgan' 'attendee' 5 'Azure Ops')
)

$sessions=@();$sessions += new_session '09:00' 'Opening Remarks: We Swear This Demo Worked Yesterday' 'Community' 'Hall A' 'Pat'
$sessions += new_session '09:45' 'Agentic Workflows for People Who Read Error Logs' 'AI + Automation' 'Hall B' 'Riley'
$sessions += new_session '10:30' 'RBAC: Why Is My Access Denied in 14 Different Ways' 'Security' 'Hall C' 'Casey'
$sessions += new_session '11:15' 'Governance Without Sadness' 'Governance' 'Hall D' 'Quinn'
$sessions += new_session '13:00' 'Lunch + Hallway Architecture Reviews' 'Community' 'Expo' 'Everyone'
$sessions += new_session '14:00' 'Copilot Prompting: Less Vibes, More Repro Steps' 'AI + Automation' 'Hall B' 'Dakota'
$sessions += new_session '15:00' 'Closing Panel: Did We Just Automate the Coffee Line?' 'Community' 'Main' 'Panel'

foreach($a in $attendees){
 if($a.coffee -ge 1){$a.checkedIn=$true}else{$a.checkedIn=$false}; $a.swag=get_swag $a -chaosMode:$IncludeChaos
 if($a.topic -match 'Prompt'){$a.note=($a.note+' '+'has 37 prompt templates and a strong opinion about delimiters').Trim()}
 if($a.role -eq 'sponsor'){$a.note=($a.note+' '+'can explain pricing tiers from memory').Trim()}
}

foreach($s in $sessions){
 $s.registered=Get-Random -Minimum 18 -Maximum 89
 if($s.registered -gt $s.capacity){$s.waitlist=$s.registered-$s.capacity}
 if($s.title -match 'RBAC|Governance|Security'){$s.tags += 'serious'}
 if($s.title -match 'Agentic|Copilot|Prompt'){$s.tags += 'hype'}
 if($s.waitlist -gt 0){$s.tags += 'overflow'}
 if($s.room -eq 'Hall B'){$s.tags += 'bring-laptop'}
}

$dayLabel=if($Day -eq 1){'DAY1_OPTIMISM'}elseif($Day -eq 2){'DAY2_REALITY'}elseif($Day -eq 3){'DAY3_ACCEPTANCE'}else{'BONUS_DAY_CHAOS'}

Write-Host ('='*52)
Write-Host "Conference: $conference"
Write-Host "City: $city | Venue: $venue"
Write-Host "WiFi: $wifi  Help Desk: $helpDesk"
Write-Host "Mode: $dayLabel"
Write-Host ('='*52)

$keynote='Today we bring enterprise-ready agentic synergy with zero trust and cleaner prompts for everyone.'
Write-Host "Buzzword Scan => $(invoke_buzzword_scan $keynote)"

Write-Host ''
Write-Host 'ATTENDEES:'
foreach($a in $attendees){
Write-Host (" - {0} [{1}] lanyard={2} coffee={3} ({4})" -f $a.name,$a.role,$a.lanyard,$a.coffee,(get_coffee_state $a.coffee))
Write-Host ("   swag: " + ($a.swag -join ', '))
 if([string]::IsNullOrWhiteSpace($a.note) -eq $false){ Write-Host ("   note: " + $a.note) }
}

Write-Host ''
Write-Host 'AGENDA:'
foreach($s in $sessions){
 $line=" * {0} {1} | {2} | room={3} | reg={4}/{5}" -f $s.time,$s.title,$s.track,$s.room,$s.registered,$s.capacity
 if($s.waitlist -gt 0){$line += " | waitlist="+$s.waitlist}
 if($s.tags.Count -gt 0){$line += " | tags="+($s.tags -join '/')} ; Write-Host $line
}

$checkedIn=($attendees|Where-Object{$_.checkedIn}).Count
$avgCoffee=[math]::Round((($attendees|Measure-Object -Property coffee -Average).Average),2)
$popular=($sessions|Sort-Object registered -Descending|Select-Object -First 1)

Write-Host ''
Write-Host 'SUMMARY:'
Write-Host " checked-in : $checkedIn / $($attendees.Count)"
Write-Host " avg coffee : $avgCoffee"
Write-Host " top session: $($popular.title) [$($popular.registered) regs]"

if($IncludeChaos){
 Write-Host ''
 Write-Host 'CHAOS MODE (SAFE DEMO):'
 1..4|ForEach-Object{Write-Host (" reminder #{0}: please stop reply-all about projectors" -f $_)}
 $snacks='pretzels','questionable muffins','sponsored trail mix','that one banana'
 Write-Host (" snack bulletin: " + ($snacks|Get-Random) + " now requires an approval workflow.")
}

Write-Host ''
Write-Host 'Done. Hydrate, commit often, and may your YAML indentations align.'
