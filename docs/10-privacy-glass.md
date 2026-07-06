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
| PDLC self-adhesive film, cut to size | $29–90/sq ft | See researched picks below; order with busbar on the edge nearest the enclosure |
| 12V DC → ~60–70V AC PDLC inverter/driver | ~$25–40 | Sold for automotive smart-film/sunroof use; size to film area |
| USB-C PD trigger board set to 12V | ~$10 | Lets a standard power bank feed the inverter |
| 100Wh USB-C PD power bank ×2 | ~$60–90 ea | Rotate; **must list 12V in its PD output table** (not all do) |
| 12V relay module (Shelly or ESP32, see below) | ~$15–25 | Switches the inverter's 12V feed |
| Slim surface enclosure + velcro battery cradle | ~$15 | Mounts on the door slab by the glass edge |

## Recommended products (researched July 2026 — verify price/stock before ordering)

**Film — pick one tier:**
- **Premium / easiest:** [InvisiShade SmartCling self-adhesive PDLC](https://invisishade.com/) —
  cut to size up to 71" wide, no on-site soldering (pre-attached leads),
  white/gray/black, ~1–2 week turnaround. Also sold in fixed panels at
  [Home Depot (ISSA4772, 47"×72")](https://www.homedepot.com/p/InvisiShade-47-24-in-x-72-in-Self-Adhesive-Switchable-Electronic-Privacy-Window-Film-ISSA4772/205453494)
  if a stock size happens to fit a slider panel.
- **Premium alternative:** [Smart Tint (shop.smarttint.com)](https://shop.smarttint.com/) —
  self-adhesive, sold by the square foot, US support.
- **Budget direct:** [pdlcglass.com self-adhesive PDLC](https://www.pdlcglass.com/products/self-adhesive-pdlc-film/)
  or [Smart Glass Country smart film](https://www.smartglasscountry.com/smart-film) —
  typical market range is [$29–75/sq ft depending on color/size/quantity](https://smartfilm.com/pages/smart-glass-cost-and-smart-glass-price).
- Choose **white** for the classic frosted "fogged" look.

**Inverter:** search "PDLC film inverter 12V" — automotive smart-film drivers
that take 12V DC in and output ~60–70V AC, sold on
[Amazon](https://www.amazon.com/Inverter-Inches-Eglass-Switchable-Electrochromic/dp/B00E7NBI0M)
and [eBay](https://www.ebay.com/itm/375013437912). Two hard requirements from
the [PDLC power-supply guidance](https://smartbuy.alibaba.com/buyingguides/power-supply-for-pdlc-smart-film):
it must output **AC** (DC destroys the liquid-crystal layer over time), and it
must be a PDLC-specific driver — never a generic LED driver. Size it to the
zone's film area; film vendors will also sell you a matched 12V driver if you
ask, which is the safest route.

**PD trigger:** the classic **ZY12PDN** trigger board (Amazon/AliExpress, ~$10)
set to 12V. Note from the
[USB-PD spec reality check](https://learn.adafruit.com/usb-pd-hacks/things-to-know):
**12V is optional in USB-PD**, so confirm the power bank explicitly lists a
12V output mode. If your preferred bank only does 15V/20V, either use a
12–24V-input inverter (common) or add a small buck converter.

**Power banks:** any reputable ~100Wh/100W USB-C bank whose spec sheet lists a
12V PD profile (check the fine print — even
[big brands skip 12V on some models](https://learn.adafruit.com/usb-pd-hacks/things-to-know)).
Two per zone, rotated through one charger.

**Relay (pick one):**
- **Simplest:** Shelly Plus 1 / Shelly 1 Gen3 — accepts 12V DC supply, dry
  contact, native local HA integration over WiFi. No battery gauge.
- **Best:** ESP32 + relay + INA219 current/voltage sensor running ESPHome —
  same switching plus real pack-voltage → battery % reporting, which feeds
  the swap alerts and the weekly watchdog. Use the ESPHome dashboard container
  (docs/09 roadmap) to build it.

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
