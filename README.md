# Crain Home Automation & Security System

Self-hosted, zero-subscription home security and automation platform replacing a
monitored Vector Security system. Built around a Synology DS923+ NAS running
Surveillance Station (video recording) and Home Assistant (automation, sensors,
announcements, dashboards).

**Ongoing cost: $0/month.** Local-first: recording, announcements, and automations
keep working if the internet is down.

## Architecture

```
                        ┌─────────────────────────────┐
                        │      Synology DS923+        │
                        │   2× 20TB RAID (~20TB use)  │
                        │                             │
                        │  ┌───────────────────────┐  │
                        │  │ Surveillance Station  │◄─┼── RTSP/ONVIF streams
                        │  │ (video recording)     │  │   from all cameras
                        │  └───────────────────────┘  │
                        │  ┌───────────────────────┐  │
                        │  │ Home Assistant        │◄─┼── Zigbee dongle (USB)
                        │  │ + Piper TTS (Docker)  │  │   ← door/window sensors
                        │  └───────────────────────┘  │
                        └──────────────┬──────────────┘
                                       │ LAN / WiFi
        ┌──────────────┬───────────────┼───────────────┬─────────────────┐
        │              │               │               │                 │
  Reolink Doorbell  4× Reolink     2× Galaxy Tab    Future:          Remote access:
  (WiFi, wired      WiFi cameras   A9+ wall panels  Sonos, pool      - Reolink app
  power)                           (HA dashboard    automation       - Synology DS cam
                                    + TTS speaker)                   - HA companion app
```

## Repository layout

| Path | Contents |
|---|---|
| `docker-compose.yml` | Home Assistant + Piper TTS stack for Synology Container Manager |
| `homeassistant/` | Complete Home Assistant configuration (mounted as `/config`) |
| `homeassistant/packages/` | Feature modules: alarm, announcements, sensors, wall panels |
| `homeassistant/dashboards/wall-panel.yaml` | Kiosk dashboard shown on the two wall tablets |
| `docs/` | Step-by-step setup guides, in install order |

## Setup guides (follow in order)

1. [`docs/01-nas-setup.md`](docs/01-nas-setup.md) — Container Manager, Zigbee dongle USB passthrough, deploying this stack
2. [`docs/02-surveillance-station.md`](docs/02-surveillance-station.md) — camera recording, retention, licenses
3. [`docs/03-zigbee-sensors.md`](docs/03-zigbee-sensors.md) — pairing door/window sensors, entity naming
4. [`docs/04-wall-panels.md`](docs/04-wall-panels.md) — Galaxy Tab A9+ with Fully Kiosk Browser
5. [`docs/05-remote-access.md`](docs/05-remote-access.md) — phone access from outside the home, kept at $0/month
6. [`docs/06-vector-cutover.md`](docs/06-vector-cutover.md) — go-live checklist before cancelling Vector monitoring

## What Home Assistant does in v1

- **Alarm modes** — a manual alarm panel (`disarmed` / `armed home` / `armed away`)
  replicating Vector's arm/disarm behavior, with entry delay in Away mode. No
  monitoring fees; alerting is push notifications + on-panel sirens (voice for now,
  Zigbee siren is a planned add-on).
- **Voice announcements** — "Front door opened", "Garage door opened", "Someone is
  at the front door" spoken through the wall panels via local Piper TTS. Bedroom
  announcements can be toggled off (e.g. at night) with one switch.
- **Doorbell popup** — a ring pops the doorbell camera fullscreen on both wall
  panels, then returns to the dashboard automatically.
- **Armed-mode alerts** — any door/window opening while armed triggers TTS alerts
  and push notifications to phones; Away mode escalates to a full alarm-triggered
  state after the entry delay.
- **Wall-panel dashboard** — doorbell + 4 camera live views, all sensor states,
  alarm keypad, announcement toggles.

## Entity naming conventions

The configuration references sensors, cameras, and panels by predictable entity IDs.
When you pair/add each device, rename its entity to match (or edit the YAML):

| Device | Entity ID |
|---|---|
| Door sensors | `binary_sensor.front_door_contact`, `binary_sensor.back_door_contact`, `binary_sensor.garage_door_contact` |
| Window sensors | `binary_sensor.<room>_window_contact` (add each to the window group in `packages/sensors.yaml`) |
| Doorbell ring | `binary_sensor.doorbell_visitor` (created by the Reolink integration) |
| Cameras | `camera.doorbell`, `camera.front_porch`, `camera.back_patio`, `camera.driveway`, `camera.side_yard` |
| Wall panels | `media_player.front_hall_panel`, `media_player.bedroom_panel` (Fully Kiosk integration) |
| TTS engine | `tts.piper` (Wyoming integration) |

## Future expansion (already accounted for)

- **Sonos** — enable the native HA Sonos integration; add the speakers to the
  announcement target lists in `packages/announcements.yaml`.
- **Pool automation** — pick an HA-supported controller (Pentair IntelliCenter,
  Jandy iAqualink, etc.); its entities surface on the same dashboards.
- **Zigbee siren** (~$30) — pair it and add a trigger action to the
  `alarm_triggered_alert` automation in `packages/alarm.yaml`.
- **More cameras** — the Surveillance Station license pack leaves 1 spare slot.
- **Smart locks / garage control** — Zigbee or WiFi devices slot into the existing
  HA + dongle infrastructure.
