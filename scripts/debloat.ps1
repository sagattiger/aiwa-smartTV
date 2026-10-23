# Disable ads/bloat on the AIWA Android TV over ADB.
#   .\debloat.ps1                     # disable the $Bloat list
#   .\debloat.ps1 -IncludeOptional    # also YouTube Music, Prime Video, Netflix
#   .\debloat.ps1 -ReplaceLauncher    # also disable the stock launcher (install Projectivy first)
#   .\debloat.ps1 -DryRun             # only print what would change
param(
    [switch]$IncludeOptional,
    [switch]$ReplaceLauncher,
    [switch]$DryRun
)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\common.ps1"
. "$PSScriptRoot\packages.ps1"

Connect-Tv
$installed = (Invoke-TvShell 'pm list packages') -replace '^package:', ''
$disabled = (Invoke-TvShell 'pm list packages -d') -replace '^package:', ''

$targets = [ordered]@{}
$Bloat.GetEnumerator() | ForEach-Object { $targets[$_.Key] = $_.Value }
if ($IncludeOptional) { $Optional.GetEnumerator() | ForEach-Object { $targets[$_.Key] = $_.Value } }

if ($ReplaceLauncher) {
    $homes = Invoke-TvShell 'cmd package query-activities --brief -a android.intent.action.MAIN -c android.intent.category.HOME' |
        Select-String '/' | ForEach-Object { ($_ -split '/')[0].Trim() } |
        Where-Object { $_ -ne $StockLauncher -and $_ -ne 'com.android.tv.settings' }
    if (-not $homes) {
        throw "No other launcher installed. Install 'Projectivy Launcher' from the Play Store first."
    }
    Write-Host "Alternative launcher found: $($homes -join ', ')"
    $targets[$StockLauncher] = 'Stock Google TV launcher (ad banner)'
}

foreach ($pkg in $targets.Keys) {
    if ($installed -notcontains $pkg) { Write-Host "skip   $pkg (not installed)"; continue }
    if ($disabled -contains $pkg) { Write-Host "skip   $pkg (already disabled)"; continue }
    Write-Host ("disable {0,-58} {1}" -f $pkg, $targets[$pkg])
    if (-not $DryRun) {
        Invoke-TvShell "am force-stop $pkg" | Out-Null
        Invoke-TvShell "pm disable-user --user 0 $pkg" | Out-Host
    }
}

# Snappier UI on the 1.8 GB / MT9632 board.
if (-not $DryRun) {
    Invoke-TvShell 'settings put global window_animation_scale 0.5'
    Invoke-TvShell 'settings put global transition_animation_scale 0.5'
    Invoke-TvShell 'settings put global animator_duration_scale 0.5'
}
Write-Host 'Done. Press HOME on the remote (reboot if the home screen looks stale).'
