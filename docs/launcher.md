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

Status: **pending**. Projectivy not installed yet.
