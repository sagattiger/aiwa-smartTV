# Stremio crashes on playback

App: `com.stremio.one` 1.11.2 (versionCode 41048578), `armeabi-v7a` (32-bit).

## What the log shows

Captured 2026-10-22 with `logcat` while starting a video. Excerpt:
[logs/stremio-oom-2026-10-22.txt](logs/stremio-oom-2026-10-22.txt).

```
21:04:47 I/StremioServer: Using app path -> /data/user/0/com.stremio.one/files/stremio-server
21:04:56 F/libc: Fatal signal 6 (SIGABRT) ... (CONCURRENT_RUNT), pid 10303 (com.stremio.one)
  #05 libstremio_core_kotlin.so (std::alloc::rust_oom)
  #06 libstremio_core_kotlin.so (__rust_alloc_error_handler)
  #07 libstremio_core_kotlin.so (alloc::alloc::handle_alloc_error)
  ...
  #25 libstremio_core_kotlin.so (tokio::runtime::scheduler::multi_thread::worker::run)
```

Stremio's Rust core asked for memory, the allocation failed, and Rust aborted the
process. This is not a codec or network error. **The app runs out of memory** about
9 s after its built-in streaming server starts, i.e. while the stream is loading.

Why this TV is prone to it:

- 1.8 GB RAM total, only ~800 MB available with the stock apps running.
- 512 MB zram swap already 60 % used before playback.
- 32-bit process: the address space fragments quickly under large allocations.
- Stock launcher (181 MB) and YouTube (133 MB) stay resident in the background.

Not the cause: Pi-hole. Blocked Crashlytics/Firebase calls only produce harmless
warnings, and `local.strem.io` resolves correctly to `127.0.0.1` on `192.168.15.102`.

## Fixes

Done from the laptop:

1. `scripts/debloat.ps1`: stops the ACR tracker, recommendation and partner services
   (`MemAvailable` 822 → 957 MB).
2. `pm trim-caches` + reboot (clears swap).

On the TV, in Stremio → **Settings**:

3. **Streaming server → Cache size → No caching** (or 2 GB at most: only 1.2 GB is free on `/data`).
4. **Player → External player**: install *Just Player* or *VLC* from the Play Store and pick it.
   Decoding then runs outside Stremio's process.
5. Prefer **1080p** streams over 4K/REMUX: huge files with many peers need more memory
   in the torrent engine. Debrid/HTTP streams are lighter than torrents.
6. Keep few addons installed. Every catalog and stream list is parsed in that same Rust core.

Habits:

7. Don't leave YouTube or other apps open before Stremio. Reboot the TV if it has been on for days.
8. Replacing the stock launcher ([launcher.md](launcher.md)) frees another ~150 MB.

## Re-test

```powershell
.\scripts\collect-logs.ps1    # play a video, Ctrl+C after it fails or plays 2 min
```

Look for `rust_oom`, `lowmemorykiller`, or `has died` near `com.stremio.one`.

Status: debloat + reboot applied, **retest pending**.
