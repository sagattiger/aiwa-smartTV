# Pi-hole / DNS

## Findings (2026-10-22)

The TV gets its DNS from DHCP: `192.168.15.102`, `192.168.15.105`.

| Server | State |
|---|---|
| `192.168.15.102` | OK. Resolves `api.strem.io`, returns `127.0.0.1` for `local.strem.io` (correct). |
| `192.168.15.105` | Was **down**: the IP `192.168.15.105/24` was not configured on the Pi-hole host (no ping, no answer on 53/udp or 80/tcp). **Fixed the same day**: now returns `127.0.0.1` for `local.strem.io`, resolves `api.strem.io`, and blocks `imasdk.googleapis.com` (`0.0.0.0`). |

Android tries servers in turn, so while `.105` was dead some lookups waited for a timeout
first, making apps and stream start-up feel slow. If one Pi-hole goes away again,
either fix it or hand out only the working one in DHCP.

The TV also has global IPv6 addresses. If the router advertises its own IPv6 DNS (RDNSS),
the TV could bypass Pi-hole over IPv6. Not seen in `dumpsys connectivity` today, but
worth checking after router changes.

## Already blocked (seen failing in the TV log)

| Domain | Who asks |
|---|---|
| `imasdk.googleapis.com` | Stock launcher, ad banner (211 attempts in ~1 min) |
| `firebase-settings.crashlytics.com`, `crashlyticsreports-pa.googleapis.com` | Stremio crash reporting |
| `firebaselogging-pa.googleapis.com` | Firebase analytics |

## Suggested additions

Exact-match blocks for Android TV ads/telemetry. Add via *Domains → Add a domain* (exact):

```
imasdk.googleapis.com
pagead2.googlesyndication.com
googleads.g.doubleclick.net
ad.doubleclick.net
static.doubleclick.net
app-measurement.com
firebase-settings.crashlytics.com
crashlyticsreports-pa.googleapis.com
```

ACR / smart-TV tracking (regex, *Add as regex*):

```
(^|\.)anoki\.(tv|io|com)$
(^|\.)samba\.tv$
(^|\.)alphonso\.tv$
```

## Do NOT block

These break things on this TV:

| Domain | Breaks |
|---|---|
| `local.strem.io` | Stremio's built-in streaming server (must resolve to `127.0.0.1`) |
| `*.strem.io`, `*.stremio.com` | Stremio login, addons, catalogs |
| `android.clients.google.com`, `play.googleapis.com` | Play Store, app updates |
| `clients3.google.com`, `connectivitycheck.gstatic.com` | Android "no internet" check |
| `www.youtube.com`, `*.googlevideo.com` | YouTube playback |

If something stops working, open Pi-hole *Query Log*, filter on client `192.168.15.128`
and look for blocked entries right when it failed.
