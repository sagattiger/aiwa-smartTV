# Device

Read with `adb shell getprop` / `dumpsys` on 2026-10-22.

| Property | Value |
|---|---|
| Brand / maker | AIWA / KTC |
| Product | `KTC_AIWA_4K_SA_21V2`, model `4K_SMART_TV`, device `zhongshan` |
| Fingerprint | `AIWA/KTC_AIWA_4K_SA_21V2/zhongshan:11/RTMA.250416.197/13994005:user/release-keys` |
| Android | 11 (SDK 30), Android TV (Google TV launcher `com.google.android.tvlauncher`) |
| SoC | MediaTek/MStar `m7632` (MT9632), userland **32-bit only** (`armeabi-v7a`) |
| RAM | 1.8 GB (`MemTotal 1830712 kB`), 512 MB zram swap |
| Storage | `/data` 4.0 GB, 1.2 GB free |
| Display | UI 1920×1080 @ 320 dpi (panel 4K) |
| Network | Ethernet `eth0`, `192.168.15.128/24`, gw `192.168.15.1`, also global IPv6 |
| WebView | 135.0.7049.111 (system) / 155.0.8059.43 (updated) |

## Memory before cleanup

`MemAvailable` ≈ 800 MB, swap 300 MB of 512 MB used. Biggest resident processes:

| PSS | Process |
|---|---|
| 181 MB | `com.google.android.tvlauncher` (stock home screen) |
| 133 MB | `com.google.android.youtube.tv` (kept in background) |
| 98 MB | `com.google.android.gms` |
| 53 MB | `com.stremio.one` (idle, before playback) |
| 39 MB | `com.google.android.katniss` (voice search) |
| 21 MB | `tv.anoki.acr.controller` (ACR tracker) |
| 18 MB | `com.google.android.tvrecommendations` |

After `debloat.ps1` + cache trim: `MemAvailable` ≈ 957 MB before reboot.

## Vendor / factory packages (left alone)

`com.ktc.tv.factory`, `ktc.factorymenu.ui`, `mediatek.factorymenu.ui`, `com.ktc.serialport`,
`com.mediatek.*` (tuner, inputs, TV center), `com.dolby.android.audio.service`.
These drive the panel, tuner, HDMI and audio. Do not disable them.
