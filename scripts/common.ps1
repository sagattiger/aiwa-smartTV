# Shared helpers: find adb and connect to the TV.
param()

$script:TvIp = if ($env:AIWA_TV_IP) { $env:AIWA_TV_IP } else { '192.168.15.128' }
$script:Serial = "$($script:TvIp):5555"

function Get-Adb {
    $cmd = Get-Command adb -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $winget = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Recurse -Filter adb.exe -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
    if ($winget) { return $winget }
    throw "adb not found. Install it with: winget install --id Google.PlatformTools -e"
}

$script:Adb = Get-Adb

function Connect-Tv {
    & $script:Adb connect $script:Serial | Out-Host
    $state = (& $script:Adb -s $script:Serial get-state 2>$null)
    if ($state -ne 'device') {
        throw "TV not ready ($state). Enable USB debugging on the TV and accept the 'Allow USB debugging?' popup."
    }
}

function Invoke-TvShell([string]$Command) {
    & $script:Adb -s $script:Serial shell $Command
}
