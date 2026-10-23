# Launcher (home screen layout)

The stock launcher `com.google.android.tvlauncher` shows the big ad banner at the top
and is also the heaviest process on the TV (~181 MB). The log shows it requesting
ad nonces from `imasdk.googleapis.com` on every start (Pi-hole already blocks them).

Disabling the recommendation/partner packages ([debloat.md](debloat.md)) removes the
sponsored rows, but the top banner only goes away by replacing the launcher.

## Replace it

1. On the TV, install **Projectivy Launcher** from the Play Store
   (light, no ads, made for Android TV; FLauncher is an alternative).
2. Open it once and accept its prompts.
3. From the laptop:

   ```powershell
   .\scripts\debloat.ps1 -ReplaceLauncher
   ```

   The script refuses to run if no other launcher is installed, so you can't end up
   without a home screen.
4. Press HOME on the remote. If Android asks which home app to use, pick Projectivy → *Always*.

## Undo

```powershell
.\scripts\restore.ps1 com.google.android.tvlauncher
```

If the TV ends up with no home screen, the `com.android.tv.settings/.system.FallbackHome`
activity still exists. Run the restore command above from the laptop.

## Applied (2026-10-22)

- Projectivy Launcher (`com.spocky.projengmenu`) installed from the Play Store, opened
  on the TV via `am start -a android.intent.action.VIEW -d market://details?id=com.spocky.projengmenu`.
- `debloat.ps1 -ReplaceLauncher` disabled `com.google.android.tvlauncher`.
- `cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity`, then HOME.

Memory: Projectivy measured **353 MB PSS during its welcome wizard**, more than the
stock launcher's 181 MB. Re-measure after setup:

```powershell
adb -s 192.168.15.128:5555 shell "dumpsys meminfo | grep projengmenu"
```

If it stays high, in Projectivy settings turn off video/animated wallpapers and
use a plain or solid background.
