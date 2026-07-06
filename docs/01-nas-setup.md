# 1 — NAS Setup: Container Manager, Zigbee Dongle, Home Assistant

## Prerequisites

- DSM 7.2+ on the Synology DS923+
- **Container Manager** installed from Package Center
- Storage pool confirmed as **SHR or RAID 1** (mirrored) — Storage Manager →
  Storage. Required redundancy for security footage.

## 1. Get this repo onto the NAS

Create a shared folder for Docker projects (e.g. `docker`), then place this
repository at `/volume1/docker/crain-home-automation` (git clone via SSH, or
upload through File Station).

## 2. Zigbee dongle (SONOFF ZBDongle-P)

1. Plug the dongle into a **rear USB port** on the NAS. Use the included USB
   extension cable to move it away from the NAS chassis and drive bays — USB 3
   and HDD interference degrade Zigbee reception badly.
2. DSM 7 removed the USB-serial kernel drivers, so the dongle will not appear
   as `/dev/ttyUSB0` out of the box. Install the community driver package:
   - Add the SynoCommunity or robertklep package source, or download the
     `synokernel-usbserial` package for DSM 7.2 / apollolake-compatible builds
     from https://github.com/robertklep/dsm7-usb-serial-drivers
   - Install the **cp210x** driver (the ZBDongle-P uses a CP2102N chip).
3. Verify over SSH: `ls /dev/ttyUSB*` should show `/dev/ttyUSB0`.
   If the path differs, update the `devices:` mapping in `docker-compose.yml`.

> The driver package must be re-checked after DSM major upgrades.

## 3. Deploy the stack

1. Container Manager → **Project** → **Create**
2. Project name: `crain-home-automation`
3. Path: `/volume1/docker/crain-home-automation` (the folder containing
   `docker-compose.yml`)
4. Source: *Use existing docker-compose.yml* → Create.
5. Both containers (`homeassistant`, `piper`) should reach **Running**.

Edit `TZ` in `docker-compose.yml` first if you're not in US Eastern time.

## 4. First-boot Home Assistant configuration

Open `http://<NAS_IP>:8123`, create the admin account, then add integrations
(Settings → Devices & Services → Add Integration):

| Integration | Notes |
|---|---|
| **Zigbee Home Automation (ZHA)** | Radio type: ZNP; serial port `/dev/ttyUSB0`, speed 115200 |
| **Reolink** | Add the doorbell and each camera by IP (create a dedicated HA user in the Reolink device settings) |
| **Wyoming Protocol** | Host: `<NAS_IP>`, port `10200` → provides the `tts.piper` entity |
| **Fully Kiosk Browser** | One entry per wall tablet (docs/04) |
| **Mobile App** | Automatic when you sign in from the HA Companion app on each phone |

After adding devices, rename entities to match the conventions in the
[README](../README.md#entity-naming-conventions) — the packaged automations
reference those exact IDs. Then Settings → System → **Restart** and check
Settings → System → Logs for any missing-entity warnings.

## 5. Give the NAS a static IP

Control Panel → Network: reserve/assign a static LAN IP for the NAS. Cameras,
tablets, and phones all point at it; set the same address in
`input_text.panel_base_url` (Controls view of the wall-panel dashboard) or in
`homeassistant/packages/wall_panels.yaml`.
