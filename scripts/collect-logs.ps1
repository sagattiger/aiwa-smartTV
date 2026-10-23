# Capture a log while reproducing a problem (e.g. Stremio playback).
#   .\collect-logs.ps1                # writes logs\tv-<timestamp>.txt, Ctrl+C to stop
param([string]$OutDir = "$PSScriptRoot\..\logs")
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\common.ps1"

Connect-Tv
New-Item -ItemType Directory -Force $OutDir | Out-Null
$file = Join-Path $OutDir ("tv-{0:yyyyMMdd-HHmmss}.txt" -f (Get-Date))
& $script:Adb -s $script:Serial logcat -c
Write-Host "Logging to $file - reproduce the problem on the TV, then press Ctrl+C."
& $script:Adb -s $script:Serial logcat -v time | Tee-Object -FilePath $file |
    Select-String -Pattern 'FATAL|ANR|lowmemorykiller|stremio|MediaCodec.*error|ExoPlayer' |
    ForEach-Object { $_.Line }
