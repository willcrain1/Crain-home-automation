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
| `homeassistant/packages/` | One feature module per concern — security: `sensors`, `alarm`, `announcements`, `wall_panels`; whole-home: `garage`, `climate`, `lighting`, `appliances`, `generator`, `power`, `vacuum`, `media`, `network`; free tier: `presence`, `nas_health`, `weather`, `briefing`, `speedtest`, `battery_watchdog`; NAS services: `surveillance`, `plex`; `privacy_glass` (battery PDLC film), `lock` (Yale Zigbee deadbolt); Florida & protection: `hurricane`, `water`, `mailbox` |
| `scripts/nas-deploy.sh` | Self-deploy: DSM Task Scheduler pulls this repo, validates, restarts HA |
| `homeassistant/dashboards/wall-panel.yaml` | Kiosk dashboard shown on the two wall tablets |
| `docs/` | Step-by-step setup guides, in install order |

## Setup guides

**Start with [`docs/00-install-roadmap.md`](docs/00-install-roadmap.md)** — the
whole plan phased by value per dollar. Phase 0 costs $0 and connects everything
already in the house (announcements run through the Echos until the wall
panels are purchased — the config adapts automatically). The remaining docs
are referenced from the roadmap phase by phase:

1. [`docs/01-nas-setup.md`](docs/01-nas-setup.md) — Container Manager, Zigbee dongle USB passthrough, deploying this stack
2. [`docs/02-surveillance-station.md`](docs/02-surveillance-station.md) — camera recording, retention, licenses
3. [`docs/03-zigbee-sensors.md`](docs/03-zigbee-sensors.md) — pairing door/window sensors, entity naming
4. [`docs/04-wall-panels.md`](docs/04-wall-panels.md) — Galaxy Tab A9+ with Fully Kiosk Browser
5. [`docs/05-remote-access.md`](docs/05-remote-access.md) — phone access from outside the home, kept at $0/month
6. [`docs/06-vector-cutover.md`](docs/06-vector-cutover.md) — go-live checklist before cancelling Vector monitoring
7. [`docs/07-device-integrations.md`](docs/07-device-integrations.md) — whole-home devices: garage (ratgdo), ELEGRP switches, GE appliances, Nest, Generac, Alexa, Shark vacuum, Frame TVs, Govee, Deco, UPS
8. [`docs/08-free-integrations.md`](docs/08-free-integrations.md) — presence/auto-arm, NAS health, weather alerts, calendar + morning briefing, speedtest, battery watchdog
9. [`docs/09-nas-services.md`](docs/09-nas-services.md) — auto-deploy via Task Scheduler, Synology Photos on panels, Plex, Uptime Kuma, InfluxDB + Grafana, Surveillance Station Home Mode sync
10. [`docs/10-privacy-glass.md`](docs/10-privacy-glass.md) — battery-powered PDLC "fog on demand" film for the glass front door and back sliders: researched product picks, battery math, wiring
11. [`docs/11-smart-lock.md`](docs/11-smart-lock.md) — Yale Assure Lock 2 + Zigbee module: why, alternatives, install, automations
12. [`docs/12-water-and-mailbox.md`](docs/12-water-and-mailbox.md) — leak sensors + auto water shutoff valve, mailbox sensor: shopping list and install
13. [`docs/13-local-voice.md`](docs/13-local-voice.md) — local voice control (Assist): Whisper/Piper/openWakeWord pipeline, phones/panels/Voice PE satellites

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
  alarm keypad, announcement toggles, plus a House view (garage, thermostat,
  lights, appliances, vacuum, TVs, generator, internet status).

## Whole-home automations (v1.1)

Arming/disarming is the backbone — one action runs the whole house:

| Event | What happens |
|---|---|
| **Armed away** (after exit delay) | Interior lights off · TVs to Art Mode/standby · Nest to Eco · garage auto-closes (toggle) · Shark starts cleaning 15 min later (toggle) · alert if the oven was left on |
| **Disarmed** (coming home) | Nest resumes schedule · entry lights on if after dark · vacuum returns to dock |
| **Alarm triggered** | Every interior + outdoor light to 100% · voice siren + push (existing) |
| **Doorbell ring** | TVs pause · outdoor lights boost to 100% after dark · camera popup + announcement (existing) |
| **Power goes out** (UPS on battery) | Instant announcement + push; escalates if the generator hasn't started within 3 min; low-battery warning before the NAS's safe shutdown |
| **Generator starts** | "Utility power may be out" on panels (which stay powered) + push |
| **Internet drops/returns** | Panels announce it, with a reminder that recording and the alarm still work |
| **Dishwasher done / oven on 3 hrs / vacuum stuck** | Announcement or push |
| **Everyone leaves, alarm disarmed** | Push reminder — or auto-arm away (toggle) |
| **Every morning** (set time, someone home) | Briefing: weather, calendar, open doors/garage |
| **Severe weather / freeze tonight** | NWS alert announced + pushed; freeze warning at 8 PM |
| **NAS drive unhealthy / volume 85% full** | Critical alert — the footage lives there |
| **Speed test under your floor / battery under 20%** | Push (weekly summary for batteries) |
| **NWS hurricane/tropical storm warning** | Hurricane mode auto-activates: garage closes, glass fogs, cameras go continuous, prep checklist announced with generator + UPS status |
| **Indoor temp > 82°F while armed away** | "Possible AC failure" push (Florida mold insurance) |
| **Water leak detected** | Critical announcement + push naming the location; main valve auto-closes (toggle) |
| **Mailbox opens** | "Mail has arrived" (daytime, 2-hour cooldown) |

Announcements can also play on every Echo in the house (Alexa Media Player,
toggle on the Controls view); alarm-critical messages always include them.

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
| Garage door (ratgdo) | `cover.garage_door` (ESPHome integration) |
| Thermostat | `climate.thermostat` (Nest integration) |
| ELEGRP switches | `light.<room>` — list each in the groups in `packages/lighting.yaml` |
| Govee outdoor | `light.govee_*` — list in the Outdoor Lights group |
| Frame TVs | `media_player.living_room_tv`, `media_player.bedroom_tv` |
| Shark vacuum | `vacuum.shark` |
| Internet monitor | `binary_sensor.internet` (Ping integration, host 8.8.8.8) |
| UPS (CyberPower) | `sensor.ups_status_data`, `sensor.ups_battery_charge` (NUT integration via DSM) |
| Surveillance Station Home Mode | `switch.nas_home_mode` (Synology DSM integration) |
| Plex living-room player | `media_player.plex_living_room_tv` |
| Privacy glass relays (ON = clear) | `switch.front_door_glass_clear`, `switch.back_sliders_glass_clear` + `sensor.*_glass_battery` |
| Front door lock | `lock.front_door`, `sensor.front_door_lock_battery` (ZHA) |
| GE appliances / Generac | mapped via template sensors in `packages/appliances.yaml` / `packages/generator.yaml` |

## Future expansion (already accounted for)

- **Sonos** — enable the native HA Sonos integration; add the speakers to the
  announcement target lists in `packages/announcements.yaml`.
- **Pool automation** — pick an HA-supported controller (Pentair IntelliCenter,
  Jandy iAqualink, etc.); its entities surface on the same dashboards.
- **Zigbee siren** (~$30) — pair it and add a trigger action to the
  `alarm_triggered_alert` automation in `packages/alarm.yaml`.
- **More cameras** — the Surveillance Station license pack leaves 1 spare slot.
- **Alexa voice control of HA devices** — Matter Hub bridge container (free);
  see docs/07.
