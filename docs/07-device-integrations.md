# 7 — Device Integrations (whole-home expansion)

How each existing household device joins Home Assistant, what you get, and the
gotchas. Several need **HACS** (Home Assistant Community Store) — install that
first.

## HACS (one-time)

```
# SSH to the NAS, then:
docker exec -it homeassistant bash -c "wget -O - https://get.hacs.xyz | bash -"
```
Restart HA, then Settings → Devices & Services → Add Integration → **HACS**
and follow the GitHub device-authorization prompt. HACS is free.

---

## myQ garage door → ratgdo  ⚠️ hardware required

**Chamberlain blocked all third-party myQ API access in November 2023.** The HA
myQ integration was removed and cannot return; the myQ app keeps working but
nothing else can talk to it.

The community-standard replacement is **ratgdo** (~$45, [ratgdo.com](https://ratgdo.com)):
a small board that wires to the opener's terminals (or hangs off Security+ 2.0
wall-button wires). It's *better* than myQ was — 100% local, instant state, and
adds obstruction + motion sensors. Flash the ESPHome firmware (browser-based
installer), join it to WiFi, and HA auto-discovers it via the **ESPHome**
integration.

- Rename the cover entity to `cover.garage_door`
- `packages/garage.yaml` then gives you: left-open reminders, auto-close when
  arming away, and a 10:30 PM auto-close safety net (toggle on the Controls view)
- Keep using the myQ app in parallel if you like; ratgdo doesn't interfere

## ELEGRP light switches → Tuya

ELEGRP switches are Tuya-based WiFi devices.

1. **Official Tuya integration** (built-in): create a free account at
   [iot.tuya.com](https://iot.tuya.com) (cloud development project), link your
   ELEGRP/Smart Life app account, add the Tuya integration in HA. All switches
   appear as `light`/`switch` entities.
2. *(Optional, later)* **LocalTuya** (HACS) removes the cloud dependency for
   fully local control — more setup per device (local keys).

Rename entities to room names (`light.kitchen`, `light.living_room`, …) and
list them in the groups in `packages/lighting.yaml`. You get: all-off when
arming away, welcome-home entry lights after dark, all-on full brightness if
the alarm triggers, and wall-panel control.

## GE oven & dishwasher → GE Home (SmartHQ)

HACS → Integrations → search **"GE Home (SmartHQ)"** ([simbaja/ha_gehome](https://github.com/simbaja/ha_gehome)).
Sign in with your SmartHQ account. Cloud-based, free.

Then map the two template sensors at the top of `packages/appliances.yaml` to
the real entity IDs the integration created (Developer Tools → States, search
"oven" / "dishwasher"). You get: dishwasher-finished announcement, oven-on-for-
3-hours reminder, and an "oven is still on" alert if you arm away.

## Google Nest thermostat → Nest (official)

Built-in **Nest** integration via Google's Smart Device Management API.
One-time **$5 Google Device Access fee** (no recurring cost — NFR1 intact).
Follow the HA docs walkthrough exactly (Google Cloud project + Device Access
project + OAuth): https://www.home-assistant.io/integrations/nest/

Rename the climate entity to `climate.thermostat`. You get: auto-Eco when
armed away, resume on return, and a thermostat card on the wall panels.

## Generac generator → ha-generac

HACS → Integrations → **"Generac"** ([bentekkie/ha-generac](https://github.com/bentekkie/ha-generac)).
Signs into your Mobile Link account (cloud polling, free).

Map the template sensor in `packages/generator.yaml` to the status entity it
creates. You get: "generator is running — utility power may be out" announced
on the panels (which keep working on generator power), power-restored notice,
and a problem-state push alert.

## Alexa devices → two directions

**1. Echos as announcement speakers (in this repo):** HACS →
**"Alexa Media Player"**. Sign in with your Amazon account. Flip
*Announce on Alexa Devices* on the Controls view and every announcement also
plays on every Echo; alarm-critical messages always include them.

**2. Voice control of HA devices ("Alexa, turn off the kitchen lights"):**
the $0/month path is the **Home Assistant Matter Hub** community bridge
(github.com/t0bst4r/home-assistant-matter-hub — runs as one more container
next to HA) which exposes HA entities to Alexa as Matter devices. Alternative:
Nabu Casa ($6.50/mo — violates NFR1, skip). Since ELEGRP/Govee/myQ already
have native Alexa skills, wiring Alexa→HA is optional; start with direction 1.

## Shark robot vacuum → Shark IQ (official)

Built-in **Shark IQ** integration — sign in with your SharkClean account.
Rename the entity to `vacuum.shark`. You get: auto-clean 15 minutes after
arming away (toggle on Controls view), return-to-dock when you come home, and
a stuck-vacuum push alert.

## Samsung Frame TVs → Samsung Smart TV (official)

Auto-discovered on the LAN (give both TVs DHCP reservations); accept the
permission popup on each screen. Rename to `media_player.living_room_tv` and
`media_player.bedroom_tv`. You get: TVs to Art Mode/standby when arming away,
auto-pause when the doorbell rings, and media cards on the panels.
Note: "off" on a Frame TV = Art Mode, same as the physical remote.

## CyberPower UPS (EC450G) → NUT via the NAS

The UPS the NAS is plugged into has a USB data port — use it. This gives HA an
**instant, local** power-outage signal (the Generac cloud status lags by
minutes) and lets DSM shut the NAS down safely if an outage outlasts both the
generator and the battery.

1. Connect the UPS's USB data cable to the NAS's free USB port.
2. DSM → Control Panel → Hardware & Power → **UPS** tab:
   - Enable UPS support (mode: USB UPS) — DSM shows model/charge when detected
   - Set "time before DiskStation enters Safe Mode" (e.g. 5 minutes)
   - Enable **Network UPS server** and add the NAS's own LAN IP to the
     permitted DiskStation devices (HA runs on the NAS, so it connects to
     that same address)
3. HA → Add Integration → **Network UPS Tools (NUT)**:
   host = NAS IP, port `3493`, username `monuser`, password `secret`
   (fixed DSM defaults, LAN-only).

`packages/power.yaml` then announces outages instantly, announces restoration,
warns if the generator *hasn't* started 3 minutes into an outage (the failure
case that actually matters), and pushes a low-battery heads-up before DSM's
safe shutdown. The wall tablets have their own batteries, so announcements
survive an outage — **plug the nearest Deco WiFi node into the UPS battery
outlets** if it's within reach, and the whole alert path stays alive.

Note: 450VA is sized for the NAS alone (roughly 15–30 minutes of runtime) —
fine for its job of bridging the generator transfer. Don't add the TVs to it.

## Rachio sprinklers (3 zones) → Rachio (official)

Built-in integration: get an API key from the Rachio app (Account Settings →
Get API Key), add via UI. Rename the zone switches to
`switch.rachio_zone_front_yard` / `_back_yard` / `_side_yard`, plus
`switch.rachio_rain_delay` and `binary_sensor.rachio_controller_online`.

`packages/irrigation.yaml` deliberately leaves scheduling to Rachio's own
Weather Intelligence and adds what Rachio can't: zone switches on the House
dashboard (and Assist voice — "water the back yard"), watering stopped +
rain delay held through hurricane mode, watering stopped when a leak closes
the water main, and an offline watchdog (a dead controller in a Florida
summer = a dead lawn, silently).

Caveat: Rachio pushes real-time state via webhooks, which requires HA to be
reachable from the internet. With the Tailscale-only remote setup, zone
*control* works fine but switch states may lag until a refresh — cosmetic,
not functional. If you later add the reverse-proxy option (docs/05 option B),
webhooks start working and states go live.

## AT&T internet + Deco mesh → monitoring & presence

- **Internet monitor:** add the built-in **Ping** integration (host `8.8.8.8`,
  name "Internet"). `packages/network.yaml` announces outages ("cameras still
  recording, alarm still works") and restoration.
- **Deco (optional):** HACS **"TP-Link Deco"** adds phone presence
  (device_tracker) and per-device network info. The HA Companion app's own
  device_tracker is usually the better presence source; Deco is a fallback for
  phones without the app.
- Give every fixed device (NAS, cameras, tablets, TVs, ratgdo) a **DHCP
  reservation in the Deco app** — integrations break when IPs drift.

---

## Cloud vs local reality check (NFR3)

| Keeps working with internet down | Needs cloud (vendor account, still $0/mo) |
|---|---|
| Cameras/recording, Zigbee sensors, alarm, TTS panels, ratgdo garage, Samsung TVs, Govee (LAN models), LocalTuya (if set up) | Tuya (default), SmartHQ appliances, Nest, Generac Mobile Link, Shark, Alexa Media Player |

Security and life-safety functions are all in the local column by design; the
cloud column is convenience-only.
