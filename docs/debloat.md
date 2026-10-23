# Debloat

All changes use `pm disable-user --user 0`: the app stays on the system partition,
stops running and disappears from the UI. `scripts/restore.ps1` or a factory reset
brings it back. Nothing was uninstalled.

## Disabled (default list)

| Package | Why |
|---|---|
| `tv.anoki.acr.controller` | Anoki ACR (automatic content recognition): samples what is on screen, including HDMI inputs, for ad targeting. ~21 MB RAM. |
| `com.google.android.tvrecommendations` | Feeds sponsored/recommended rows on the home screen. ~18 MB RAM. |
| `com.mediatek.android.leanbacklauncher.partnercustomizer` | Vendor-promoted rows and pinned app slots. |
| `android.autoinstalls.config.ktc.pai` | Play "PAI" config: silently installs partner apps after setup/updates. |
| `fusion.android.tv.demo` | Store demo mode. |
| `com.google.android.play.games` | Unused. |
| `com.google.android.feedback` | Google feedback/crash reporter. |
| `com.cltv.fast` | FAST ad-supported channels. Was already disabled by firmware; shell cannot change it (`SecurityException`), so the script skips it. |

## Optional (`-IncludeOptional`)

YouTube Music, Prime Video, Netflix. Not disabled by default because they may be used.

## Kept on purpose

| Package | Why kept |
|---|---|
| `com.google.android.katniss`, `com.google.android.tv.assistant` | Voice search on the remote. |
| `com.google.android.apps.mediashell` | Chromecast built-in. |
| `com.google.android.backdrop` | Ambient screensaver. |
| `com.google.android.youtube.tv` | YouTube. |
| `com.android.vending`, `com.google.android.gms` | Play Store / Play services. Disabling them breaks Stremio login and app updates. |
| `com.mediatek.*`, `com.ktc.*`, `*factorymenu*` | Tuner, inputs, panel, factory menu. |

## Other tweaks

Window/transition/animator scales set to `0.5` (snappier menus on the slow SoC).

## Applied

2026-10-22, see [changelog.md](changelog.md). Verify with:

```powershell
adb -s 192.168.15.128:5555 shell pm list packages -d
```
