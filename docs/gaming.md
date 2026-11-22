# Gaming (Xbox Series S)

Read over ADB on 2026-11-22 (`dumpsys display`, `dumpsys hdmi_control`, `settings list global`).
Read only, nothing changed.

## What the TV supports

| Feature | Result | Source |
|---|---|---|
| Refresh rate | **60 Hz only** (no 120 Hz mode) | `supportedModes [{1920x1080, fps=60}]` |
| HDR | **HDR10 + HLG**. No Dolby Vision, no HDR10+ | `mSupportedHdrTypes=[2, 3]` |
| Peak brightness (reported) | 500 nits | `mMaxLuminance=500.0` (vendor value, real panel likely lower) |
| ALLM (auto Game mode) | **Supported, but turned off** | `allmSupported true`, `tv_picture_video_allm=0` |
| Game content type | Not supported | `gameContentTypeSupported false` |
| HDMI ports | 4 inputs, ARC on **HDMI 1** | `mPortInfo` |
| HDMI EDID | `tv_input_hdmi_edid_version=2` (confirm it shows 2.0 in the menu) | settings |
| HDMI-CEC | Off | `hdmi_control_enabled=0` |
| Input label | HDMI 4 is labelled "Game console" | `tv_input_custom_labels` |

The Android UI runs at 1920×1080. The 4K panel is used for HDMI and video, so the
1080p UI mode does not limit the Xbox.

## Picture processing currently on (values from the last-used input)

| Setting | Value | For gaming |
|---|---|---|
| Game mode | 0 (off) | **On** |
| ALLM | 0 (off) | **On** |
| MJC / motion smoothing | 2 (on) | **Off** (adds lag) |
| DNR | 4 | **Off** |
| MPEG NR | 2 | **Off** |
| AI super resolution (AISR) | 3 | **Off** (Series S already upscales) |
| Adaptive luma / local contrast | 2 / 2 | Low or Off |
| Low blue light | 1 (on) | Off (it tints the image) |
| Sharpness | 8 | Fine |
| HDMI RGB range | 0 (auto) | Leave on auto; Xbox color space *Standard* |

Picture settings on MediaTek TVs are per input and per picture mode. Set them while the
Xbox input is on screen.

## Xbox Series S settings for this TV

- Resolution **4K UHD**, refresh **60 Hz** (no 120 Hz panel).
- Allow 4K **on**, Allow HDR10 **on**. Dolby Vision is not offered (TV lacks it).
- **Allow Auto Low-Latency Mode on**, and turn ALLM on in the TV too.
- VRR off/unavailable.
- Color depth 10-bit (8-bit if flicker), color space Standard.
- Run *Calibrate TV* and the *Xbox HDR Game Calibration* app.
- HDMI-CEC: enable on the TV if you want the Xbox to turn the TV on and switch input.
- Audio: TV speakers → HDMI audio Stereo uncompressed. A soundbar on HDMI 1 (ARC) can carry Dolby Digital.
