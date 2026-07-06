# 11 — Smart Door Lock

Package: `homeassistant/packages/lock.yaml`. Entity: `lock.front_door`.

## Recommendation: Yale Assure Lock 2 + Yale Zigbee Smart Module

**Why this one** (researched July 2026):

- **Joins the Zigbee mesh you already run.** Yale's swappable
  [Smart Module](https://shopyalehome.com/products/yale-zigbee-smart-module)
  drops into the lock and pairs with ZHA like your door sensors —
  [confirmed working with ZHA and Zigbee2MQTT by HA community users](https://community.home-assistant.io/t/yale-assure-lock-code-management-with-zigbee2mqtt/780391).
  No new hub, no cloud account, no subscription — it pairs and reports
  locally over the same mesh as the door sensors.
- **Local + $0/month** — control and state stay on the LAN (NFR1/NFR3).
- **Keypad + auto-relock + physical key backup.** Get the keyed variant, not
  Key-Free, so a dead battery never locks you out (4×AA, months of life; the
  package pushes an alert at 25%).
- **Buying:** Yale Assure Lock 2 keypad deadbolt ~$160–230 depending on
  touchscreen vs push-button and finish, plus the Zigbee module (~$50) —
  [Yale's store](https://shopyalehome.com/products/yale-zigbee-smart-module)
  or Amazon. Make sure the listing is the **Zigbee** module/bundle, not
  WiFi or Z-Wave.

### Alternatives considered

| Lock | Verdict |
|---|---|
| [Aqara U100](https://www.aqara.com/us/product/smart-lock-u100/) (fingerprint, ~$190) | Tempting hardware, but [not HA-compatible via Aqara's integration and needs an Aqara hub](https://sawherodoorlock.com/blogs/news/home-assistant-compatible-smart-lock) (then Matter-bridged) — an extra hub + cloud app in a local-first system. Skip. |
| [Ultraloq U-Bolt Pro Z-Wave](https://u-tec.com/products/ultraloq-u-bolt-pro-series) (fingerprint, ~$200–250) | [Works with HA as a Z-Wave partner](https://www.prnewswire.com/news-releases/ultraloq-u-bolt-pro-z-wave-smart-lock-now-works-with-home-assistant-301659657.html), but requires adding a Z-Wave USB stick — and both NAS USB ports are taken (Zigbee + UPS). Only worth it if fingerprint entry is a must; budget a powered USB hub too. |
| Schlage Encode / Encode Plus (WiFi) | Cloud-dependent WiFi lock; fine product, wrong architecture for this system. |

## Install & pairing

1. Install the deadbolt (standard bore; fits like the Vector-era hardware).
   Note for the glass front door: confirm the door has a standard cross-bore —
   full-glass doors sometimes use narrow-stile hardware; measure before buying.
2. Insert the Zigbee Smart Module (slot under the battery cover), then in HA:
   Settings → Devices & Services → ZHA → Add device, and put the lock in
   pairing mode per its manual.
3. Rename entities: `lock.front_door`, `sensor.front_door_lock_battery`.
4. Set keypad codes at the lock/app; enable its built-in auto-relock if you
   want belt-and-suspenders on top of the automations.

## What the package automates

| Trigger | Action |
|---|---|
| Alarm armed (home or away) | Deadbolt locks |
| 10:30 PM and unlocked | Locks + panel announcement |
| House empty 5 min and unlocked | Locks + push |
| Bolt jams | Critical announcement + push (a jam looks like success otherwise) |
| Battery < 25% | Early push (watchdog also covers it weekly) |
| Keypad unlock while armed away | *(Optional, commented)* auto-disarm — enable after checking your lock's `zha_event` codes |
