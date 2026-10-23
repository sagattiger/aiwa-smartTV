# Resize/crop wallpapers to 1920x1080 JPEG and push them to the TV.
#   .\prepare-wallpapers.ps1 -Source C:\Users\eliso\Pictures\Wallpapers
#   .\prepare-wallpapers.ps1 -Source ... -NoPush     # only build the resized set
param(
    [Parameter(Mandatory)][string]$Source,
    [string]$OutDir = "$env:TEMP\aiwa-wallpapers",
    [string]$TvDir = '/sdcard/Pictures/Wallpapers',
    # Projectivy's "Folder" wallpaper source reads from here by default (Premium).
    [string]$ProjectivyDir = '/sdcard/Android/data/com.spocky.projengmenu/files/wallpapers',
    [int]$Width = 1920,
    [int]$Height = 1080,
    [int]$Quality = 85,
    [switch]$NoPush
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

New-Item -ItemType Directory -Force $OutDir | Out-Null
Get-ChildItem $OutDir -File | Remove-Item

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'
$params = New-Object System.Drawing.Imaging.EncoderParameters 1
$params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), ([long]$Quality)

$files = Get-ChildItem $Source -File | Where-Object Extension -in '.jpg', '.jpeg', '.png', '.webp', '.bmp'
foreach ($f in $files) {
    try { $src = [System.Drawing.Image]::FromFile($f.FullName) } catch { Write-Warning "skip $($f.Name): $_"; continue }
    # Scale to cover the target, then center-crop.
    $scale = [Math]::Max($Width / $src.Width, $Height / $src.Height)
    $w = [int][Math]::Ceiling($src.Width * $scale); $h = [int][Math]::Ceiling($src.Height * $scale)
    $bmp = New-Object System.Drawing.Bitmap $Width, $Height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($src, [int](($Width - $w) / 2), [int](($Height - $h) / 2), $w, $h)
    $name = ($f.BaseName -replace '[^\w\-]+', '_') + '.jpg'
    $bmp.Save((Join-Path $OutDir $name), $codec, $params)
    $g.Dispose(); $bmp.Dispose(); $src.Dispose()
}
$out = Get-ChildItem $OutDir -File
Write-Host ("{0} images, {1:N1} MB in {2}" -f $out.Count, (($out | Measure-Object Length -Sum).Sum / 1MB), $OutDir)

if (-not $NoPush) {
    . "$PSScriptRoot\common.ps1"
    Connect-Tv
    Invoke-TvShell "rm -rf '$TvDir'; mkdir -p '$TvDir'"
    & $script:Adb -s $script:Serial push "$OutDir\." $TvDir | Select-Object -Last 1
    # Let the gallery/media pickers see the new files.
    Invoke-TvShell "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d 'file://$TvDir'" | Out-Null
    Invoke-TvShell "ls '$TvDir' | wc -l"
    if ($ProjectivyDir) {
        Invoke-TvShell "rm -rf '$ProjectivyDir'; mkdir -p '$ProjectivyDir'; cp '$TvDir'/*.jpg '$ProjectivyDir'/"
        # Restart the launcher so it rescans the folder.
        Invoke-TvShell 'am force-stop com.spocky.projengmenu; input keyevent KEYCODE_HOME'
    }
}
