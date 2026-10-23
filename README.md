# aiwa-smartTV

Cleanup and troubleshooting notes for an **AIWA 4K Android TV** (KTC board, Android TV 11),
done from a Windows laptop over ADB on the home LAN. Nothing is rooted and nothing is
uninstalled: every change is a `pm disable-user` that `scripts/restore.ps1` undoes.

| | |
|---|---|
| TV IP | `192.168.15.128` (wired, `eth0`) |
| DNS | Pi-hole `192.168.15.102` + `192.168.15.105`, see [docs/pihole.md](docs/pihole.md)) |
| Device | [docs/device.md](docs/device.md) |

## What was wrong

1. **Ads and tracking on the home screen.** Sponsored rows, vendor-promoted apps and an
   ACR tracker (`tv.anoki.acr.controller`) that fingerprints what is on screen.
2. **Stremio crashed on every video.** Its native core ran out of memory (`rust_oom` →
   `SIGABRT`) on a 1.8 GB board where ~800 MB was free and swap was 60 % used.
   Details: [docs/stremio.md](docs/stremio.md).
3. **Second DNS server dead.** The TV gets `192.168.15.102` and `192.168.15.105`; `.105`
   did not answer (IP not configured on the server), so some lookups stalled until
   timeout. Fixed 2026-10-22.

## Quick start

```powershell
winget install --id Google.PlatformTools -e      # adb
cd scripts
.\debloat.ps1 -DryRun                            # see what would change
.\debloat.ps1                                    # apply
.\restore.ps1                                    # undo everything
```

First connection: on the TV enable **Developer options → USB debugging**
(Settings → Device Preferences → About → click *Build* 7×). This firmware has no
"Network debugging" toggle, but with USB debugging on, ADB still listens on TCP 5555.
Accept the **Allow USB debugging?** popup and tick *Always allow*.

Set `$env:AIWA_TV_IP` if the TV's address changes.

## Scripts

| Script | What it does |
|---|---|
| [scripts/debloat.ps1](scripts/debloat.ps1) | Disables the ad/bloat list, halves UI animations. `-IncludeOptional`, `-ReplaceLauncher`, `-DryRun`. |
| [scripts/restore.ps1](scripts/restore.ps1) | Re-enables all (or named) packages, resets animations. |
| [scripts/packages.ps1](scripts/packages.ps1) | The package lists and why each one is there. |
| [scripts/prepare-wallpapers.ps1](scripts/prepare-wallpapers.ps1) | Resizes a folder of images to 1920×1080 and pushes it to the TV. |
| [scripts/collect-logs.ps1](scripts/collect-logs.ps1) | Records `logcat` to `logs/` while you reproduce a problem. |

## Docs

- [docs/device.md](docs/device.md): hardware, firmware, memory
- [docs/debloat.md](docs/debloat.md): what was disabled and why, what was kept
- [docs/launcher.md](docs/launcher.md): replacing the ad-banner launcher
- [docs/stremio.md](docs/stremio.md): crash analysis and fixes
- [docs/pihole.md](docs/pihole.md): DNS findings and blocklist
- [docs/wallpapers.md](docs/wallpapers.md): custom home screen backgrounds
- [docs/usb-storage.md](docs/usb-storage.md): does a USB stick help?
- [docs/changelog.md](docs/changelog.md): what was done to the TV, when
