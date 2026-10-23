# USB stick: does it help?

Short answer: **more space, not more speed.**

- The slowness and the Stremio crashes come from **RAM** (1.8 GB), not storage.
  A USB stick cannot add RAM, and Android won't swap to it without root.
- Flash sticks are slower than the internal eMMC, especially for small random
  reads. Apps moved onto one usually start *slower*.
- `sm has-adoptable` returns `true`, so the TV can format a stick as internal
  ("adoptable") storage. That is useful only if the 1.2 GB free on `/data` runs out.

## If you want the space anyway

- Use a USB 3.0 stick from a good brand, 32 GB or larger. 8 GB gains little after formatting.
- Settings → Device Preferences → Storage → pick the stick → **Set up as device storage**.
  This **erases** the stick, and it then only works in this TV.
- Keep Stremio, Play services and the launcher on internal storage.
- Never pull the stick out while the TV is on: apps stored on it will break.

As plain removable storage (photos, videos played from a file manager), any stick works
without these caveats.
