# Re-enable everything debloat.ps1 can disable.
#   .\restore.ps1                 # all packages
#   .\restore.ps1 com.netflix.ninja   # just one
param([string[]]$Packages)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\common.ps1"
. "$PSScriptRoot\packages.ps1"

Connect-Tv
if (-not $Packages) { $Packages = @($Bloat.Keys) + @($Optional.Keys) + $StockLauncher }

foreach ($pkg in $Packages) {
    Write-Host "enable $pkg"
    Invoke-TvShell "pm enable $pkg" | Out-Host
}
Invoke-TvShell 'settings put global window_animation_scale 1'
Invoke-TvShell 'settings put global transition_animation_scale 1'
Invoke-TvShell 'settings put global animator_duration_scale 1'
