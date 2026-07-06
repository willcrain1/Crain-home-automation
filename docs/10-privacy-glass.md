# 10 — Battery-Powered Privacy Glass (PDLC film)

Switchable "fog on demand" film for the glass front door and back sliders,
fully battery powered — no wires leaving any door, and simple on the sliding
panels. Package: `homeassistant/packages/privacy_glass.yaml`.

## How it behaves

- **Fogged (private) is the default and the fail-safe** — PDLC film is opaque
  with no power, so a dead battery means privacy, never exposure.
- Press a wall-panel button (or Alexa, or phone) → glass goes clear instantly.
- It **auto-refogs** after a set number of minutes (Controls view, default 30)
  — this is what makes battery power practical, since fogged draws zero.
- Arming the alarm or a doorbell ring fogs everything relevant automatically.

## Why battery works here (the math)

PDLC draws ~4W/m² only while CLEAR, plus ~0.3–0.5W standby for the wireless
relay. Per 100Wh power bank:

| Zone | Film area | Clear draw | ~1.5h clear/day | Swap cadence |
|---|---|---|---|---|
| Front door lite | ~0.7 m² | ~4W | ~14Wh/day | **~1 week** |
| Slider pair | ~2 m² | ~9W | ~22Wh/day | **~4–5 days** |

Buy **two packs per door zone** and rotate: one on the door, one on the
charger. If you ever leave a zone clear all day, the pack dies same-day —
the auto-refog timer is what protects you from that.

## Parts per door zone (~$150–200 + film)

| Part | Est. | Notes |
|---|---|---|
| PDLC self-adhesive film, cut to size | $20–90/sq ft | Smart Tint / InvisiShade (US) or HOHOFILM-class imports; order with busbar on the edge nearest the enclosure |
| 12V DC → ~60V AC PDLC inverter/driver | ~$25–40 | Sold for automotive smart-film/sunroof use; size to film area |
| USB-C PD trigger board set to 12V | ~$10 | Lets a standard power bank feed the inverter |
| 100Wh USB-C PD power bank ×2 | ~$60–90 ea | Rotate; any brand with 12V PD output |
| 12V Zigbee relay module (or ESP32 + relay, ESPHome) | ~$15–25 | Zigbee joins the existing mesh; ESP32 adds precise battery % reporting |
| Slim surface enclosure + velcro battery cradle | ~$15 | Mounts on the door slab by the glass edge |

Wiring: power bank → PD trigger (12V) → relay → inverter → film busbar.
The relay switches the inverter's 12V feed; everything lives in one enclosure
on the door, so the sliding panel just carries its own box — nothing crosses
the door gap.

**Battery reporting:** the ESP32/ESPHome route reports pack voltage as a
`device_class: battery` sensor — the weekly battery watchdog then includes it
automatically, and `privacy_glass.yaml` adds an immediate push below 15%.
A plain Zigbee relay works too; you just lose the gauge and swap on a fixed
schedule instead.

## Entity naming

| Zone | Relay switch (ON = clear) | Battery sensor |
|---|---|---|
| Front door | `switch.front_door_glass_clear` | `sensor.front_door_glass_battery` |
| Back sliders | `switch.back_sliders_glass_clear` | `sensor.back_sliders_glass_battery` |

Add a zone by duplicating a row and adding the switch to the
*All Privacy Glass Clear* group in the package.

## Automations you get

| Trigger | Effect |
|---|---|
| Clear switch on for N minutes (Controls view) | Auto-refog (battery saver) |
| Alarm → armed home / armed away / triggered | Fog everything |
| Doorbell ring | Fog the front door — watch the visitor on the panel popup instead |
| Pack below 15% | Push: swap the battery (glass stays private if it dies) |
| Weekly battery watchdog | Includes glass packs in the Sunday summary |

## Honest caveats

- This is a DIY assembly — no vendor sells the battery version turnkey.
  Each piece is off-the-shelf; the enclosure is the only "project" part.
- Film on a swinging/sliding door takes a careful squeegee install; order
  oversize is not possible (PDLC can't be field-trimmed cleanly) — measure
  the visible glass exactly.
- Cold weather raises PDLC haze slightly when clear; irrelevant when fogged.
- If you later add an outlet near the front door, the same relay setup runs
  wired with the battery as backup — no config changes.
