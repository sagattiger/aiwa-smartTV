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
`Folder` (and `Media file`) are **Premium** features (one-time R$37.99 via Google Play,
seen 2026-10-22). Not purchased. The source is still **Reddit**.

After buying Premium on the TV: pick **Folder** → `Pictures/Wallpapers`, then
*Image transition* and *Update frequency* to taste.

Free options without Premium:
- **Default wallpaper** or **Dynamic colors**: no internet fetches, lightest on memory.
- **Reddit** (current): rotating photos from a subreddit, downloaded over the internet.
