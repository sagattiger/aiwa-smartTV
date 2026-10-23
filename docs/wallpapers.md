# Home screen wallpapers

Source on the laptop: `C:\Users\eliso\Pictures\Wallpapers` (101 images, many 4K–8K).
On the TV: `/sdcard/Pictures/Wallpapers` (101 × 1920×1080 JPEG q85, 36 MB total).

## Why resize

The UI renders at 1920×1080 and the TV has 1.8 GB RAM. A 7680×4320 photo decodes to
~130 MB of bitmap memory. At 1920×1080 that drops to ~8 MB, so the launcher stays light
and Stremio keeps its memory.

## Update the set

```powershell
.\scripts\prepare-wallpapers.ps1 -Source C:\Users\eliso\Pictures\Wallpapers
```

Center-crops each image to fill 16:9, re-encodes to JPEG, replaces the folder on the TV
and triggers a media scan. `-NoPush` only builds the resized set locally.

## Using them in Projectivy

Projectivy → Settings → Appearance → Wallpaper → **Launcher wallpaper → Folder**.
`Folder` (and `Media file`) are **Premium** features (one-time R$37.99 via Google Play).
Premium was bought on 2026-10-22, and the source is now **Folder** (100 wallpapers shown).

Projectivy's *Configure → Uri* defaults to its own app folder:
`/sdcard/Android/data/com.spocky.projengmenu/files/wallpapers`. Instead of the file
picker, the images are copied there over ADB (`prepare-wallpapers.ps1` does this and
restarts the launcher to rescan). `Pictures/Wallpapers` keeps a copy for other apps.

Projectivy reported 100 of the 101 files. One is either skipped or over a limit.

Transition: *Zoom* (default). Change *Update frequency* in the same menu.

Free options without Premium:
- **Default wallpaper** or **Dynamic colors**: no internet fetches, lightest on memory.
- **Reddit** (current): rotating photos from a subreddit, downloaded over the internet.
