# 2 — Surveillance Station: Recording & Retention

All five Reolink devices record to the NAS (FR3). Surveillance Station is the
NVR; Home Assistant handles events/automation. They both consume the cameras'
streams independently.

## Camera prep (per device, in the Reolink app first)

1. Join the camera to WiFi and give it a **static IP / DHCP reservation**.
2. Create a dedicated user for the NAS connection (avoid sharing the admin login).
3. Enable **ONVIF/RTSP** (Settings → Network → Advanced → Port Settings on
   most Reolink firmware).
4. Verify WiFi signal strength at the final mounting spot **before** drilling.

## Licenses

DS923+ includes 2 camera licenses. Install the **4-Device License Pack**
(Surveillance Station → License) to cover 5 devices with 1 spare slot.
One-time purchase, no recurring cost.

## Add the devices

Surveillance Station → IP Camera → **Add** → Add Camera → Quick Setup:
- Brand: **ONVIF** (or Reolink if listed for the model), address = camera IP,
  the dedicated user credentials.

## Recording modes

| Device | Mode | Why |
|---|---|---|
| E1 Outdoor ×2, Argus 4 Pro ×2 | **Continuous** | 20TB ≈ 5–6 months of 4-camera continuous footage; storage is not a constraint. Battery cameras (Argus) may throttle continuous streaming — fall back to motion recording if battery drain is excessive. |
| Doorbell | **Motion + ring events** | WiFi doorbells sleep between events and do not stream 24/7 |

## Retention

Camera → Edit → Recording settings → **Keep files for 120 days** (or
space-based rotation — either is fine given the array size).

## Remote footage review

1. Enable **QuickConnect**: DSM Control Panel → External Access → QuickConnect
   (free Synology account).
2. Install **DS cam** on phones → sign in with the QuickConnect ID.
3. Live view + recorded footage playback now work from anywhere (FR7), $0/month.

> Also enable snapshot/event notifications in DS cam if you want motion alerts
> from Surveillance Station in addition to Home Assistant's.
