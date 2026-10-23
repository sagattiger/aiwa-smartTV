# Changelog (what was done to the TV)

## 2026-10-22

- Installed adb on the laptop (`winget install Google.PlatformTools`).
- TV: Developer options → USB debugging on. ADB over TCP 5555 works without a
  separate network-debugging toggle. Laptop authorized.
- Captured Stremio crash: Rust core OOM (see [stremio.md](stremio.md)).
- `debloat.ps1` applied. Disabled: `tv.anoki.acr.controller`,
  `com.google.android.tvrecommendations`,
  `com.mediatek.android.leanbacklauncher.partnercustomizer`,
  `android.autoinstalls.config.ktc.pai`, `fusion.android.tv.demo`,
  `com.google.android.play.games`, `com.google.android.feedback`
  (`com.cltv.fast` was already disabled by firmware).
- Animation scales → 0.5.
- `pm trim-caches`, rebooted. All disables survived the reboot.
- Found DNS `192.168.15.105` down: IP not set on the Pi-hole host. Fixed and verified
  (see [pihole.md](pihole.md)).

Pending: Projectivy launcher + `-ReplaceLauncher`, Stremio in-app settings, Stremio retest.
