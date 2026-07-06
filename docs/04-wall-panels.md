# 4 — Wall Panels: Galaxy Tab A9+ + Fully Kiosk Browser

Two tablets (front hall, master bedroom) replace the Vector wall touchscreens:
dashboard display + announcement speaker (FR5, FR6).

## Power (no mains work)

The existing low-voltage Vector panel wiring cannot power the tablets. Run a
slim USB-C cable through the existing wall opening to a nearby outlet, or use
an in-wall USB power kit. Mount with a generic non-VESA universal tablet mount.

Tablet battery-health tip: in Fully Kiosk (PLUS) you can automate charge
cycling; at minimum enable Android's battery protection (charge limit ~85%)
to extend life on permanent power.

## Tablet setup (each)

1. Android setup, join WiFi, verify signal at the mounting location.
2. Install **Fully Kiosk Browser** from the Play Store; buy the PLUS license
   (one-time, per device) — required for remote admin and the HA integration.
3. Fully Kiosk settings:
   - **Start URL:** `http://<NAS_IP>:8123/wall-panel/home`
   - **Kiosk mode:** on (pin-protected)
   - **Remote Administration (PLUS):** on, set an admin password, **enable
     "Remote Admin from Local Network"** — this is what HA connects to
   - **Motion detection:** on → *Turn screen on on motion*; screensaver/dim
     after 2–5 min for always-on-dim behavior
   - **Settings → Advanced Web Settings → Autoplay Videos**: on (camera views)
   - Keep screen orientation locked to the mounted orientation
4. Sign the tablet into HA once in a normal browser first if you want it to
   remember a dedicated user login. Create a dedicated HA user per panel
   (e.g. `frontpanel`) with local-only access.

## Connect to Home Assistant

Settings → Devices & Services → **Fully Kiosk Browser** → host = tablet IP
(give both tablets DHCP reservations), password = the remote admin password.

Rename the created entities:

| Tablet | Media player | Screen switch |
|---|---|---|
| Front hall | `media_player.front_hall_panel` | `switch.front_hall_panel_screen` |
| Master bedroom | `media_player.bedroom_panel` | `switch.bedroom_panel_screen` |

## Verify

- Developer Tools → Actions → run `script.announce` with message
  `Test announcement`, `both_panels: true` → both tablets speak (Piper TTS).
- Press the doorbell → both panels announce, jump to the fullscreen doorbell
  camera, and return to the dashboard after 60s.
- If the popup doesn't fire, check `input_text.panel_base_url` (Controls view)
  matches the NAS address the tablets use.
