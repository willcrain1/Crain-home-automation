# 14 — Master Shopping List

Everything left to buy, grouped by install phase (docs/00 roadmap). Prices
are July 2026 estimates — check current pricing. Manufacturer links given
where they're stable; most items are also on Amazon, often cheaper.

**Phase 0 needs nothing** — only the one-time $5
[Google Device Access fee](https://developers.google.com/nest/device-access/registration)
for the Nest integration.

---

## Phase 1 — Security core (~$150–200)

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | SONOFF ZBDongle-P (Zigbee coordinator) | 1 | ~$20 | [itead.cc](https://itead.cc/product/sonoff-zigbee-3-0-usb-dongle-plus/) |
| ☐ | SONOFF SNZB-04P contact sensors (doors + windows) | 8–10 | ~$13 ea | [itead.cc](https://itead.cc/product/sonoff-zigbee-door-window-sensor-snzb-04p/) — Aqara Door & Window is the alternative |

## Phase 2 — Cameras (~$620–760)

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | Reolink E1 Outdoor (plug-in PTZ — porch, patio) | 2 | ~$120–140 ea | [reolink.com](https://reolink.com/us/product/e1-outdoor/) |
| ☐ | Reolink Argus 4 Pro + solar panel (wire-free — driveway, perimeter) | 2 | ~$200–230 ea | [reolink.com](https://reolink.com/us/product/argus-4-pro/) |
| ☐ | Synology Surveillance Device License Pack, 4 licenses | 1 | ~$180 | [synology.com](https://www.synology.com/en-us/surveillance/license) — one-time, 1 spare slot |

## Phase 3 — Wall panels (~$500–540)

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | Samsung Galaxy Tab A9+ (11", WiFi) | 2 | ~$200–220 ea | [samsung.com](https://www.samsung.com/us/tablets/galaxy-tab-a9-plus/) — sales are frequent |
| ☐ | Fully Kiosk Browser PLUS license | 2 | ~$8 ea | [fully-kiosk.com](https://www.fully-kiosk.com/en/#licenses) |
| ☐ | Universal tablet wall mount (non-VESA) | 2 | ~$15–20 ea | Amazon: search "universal tablet wall mount 11 inch" |
| ☐ | In-wall USB-C power kit or slim 10ft USB-C cable + adapter | 2 | ~$15–20 ea | Amazon: search "in-wall tablet charging kit USB-C" |

## Phase 4 — Garage (~$45)

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | ratgdo (ESPHome version for your opener model) | 1 | ~$45 | [ratgdo.com](https://ratgdo.com) or [konnected.io](https://konnected.io/products/ratgdo) — check your opener's compatibility table before ordering |

## Phase 5 — Front door lock (~$210–280)

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | Yale Assure Lock 2 — **keyed** keypad deadbolt | 1 | ~$160–230 | [shopyalehome.com](https://shopyalehome.com/collections/assure-lock-2) — measure the glass door's cross-bore first (docs/11) |
| ☐ | Yale Zigbee Smart Module | 1 | ~$50 | [shopyalehome.com](https://shopyalehome.com/products/yale-zigbee-smart-module) — Zigbee, not WiFi/Z-Wave |

## Phase 6 — Privacy glass (~$1,500–3,800, film dominates)

Full detail + wiring in docs/10. Per-zone quantities: front door = 1 zone,
back sliders = 1–2 zones.

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | PDLC self-adhesive film, cut to size, white | ~40–60 sq ft | $29–90/sq ft | [InvisiShade](https://invisishade.com/) (premium) · [Smart Tint](https://shop.smarttint.com/) · [pdlcglass.com](https://www.pdlcglass.com/products/self-adhesive-pdlc-film/) (budget) — get quotes from all three |
| ☐ | 12V DC → 60–70V AC PDLC inverter | 1/zone | ~$25–40 | Ask the film vendor for their matched 12V driver (safest), or Amazon/eBay "PDLC film inverter 12V" |
| ☐ | ZY12PDN USB-C PD trigger board, set to 12V | 1/zone | ~$10 | Amazon/AliExpress: search "ZY12PDN" |
| ☐ | ~100Wh USB-C PD power bank **with 12V output listed** | 2/zone | ~$60–90 ea | Any reputable brand — verify 12V in the PD spec table before buying (docs/10) |
| ☐ | Shelly Plus 1 (12V DC) or ESP32 + relay + INA219 | 1/zone | ~$15–25 | [shelly.com](https://us.shelly.com/products/shelly-plus-1) — ESP32 route adds battery % (docs/10) |
| ☐ | Slim ABS project enclosure + velcro | 1/zone | ~$15 | Amazon: search "ABS project enclosure" |

## Phase 7 — Hardening & extras (à la carte, value order)

| ✓ | Item | Qty | Est. | Link |
|---|---|---|---|---|
| ☐ | SONOFF SNZB-05P water leak sensors | 5 | ~$15 ea | [itead.cc](https://itead.cc/product/sonoff-zigbee-water-leak-sensor-snzb-05p/) |
| ☐ | Zigbee water valve actuator (clamp-on, 1/2"–1") | 1 | ~$80–150 | Amazon: search "Zigbee smart water valve actuator" (Tuya-style) — docs/12 |
| ☐ | Zigbee siren (Heiman HS2WD or similar) | 1 | ~$30 | Amazon: search "Heiman Zigbee siren" — uncomment the hook in `packages/alarm.yaml` |
| ☐ | Zigbee smoke/CO detectors (Heiman HS1SA or listener) | 2–4 | ~$25–40 ea | Amazon: search "Heiman Zigbee smoke detector" |
| ☐ | SONOFF SNZB-01P buttons (bedside + garage-entry arm) | 2 | ~$11 ea | [itead.cc](https://itead.cc/product/sonoff-zigbee-wireless-switch-snzb-01p/) |
| ☐ | Mailbox contact sensor (one more SNZB-04P) | 1 | ~$13 | same as Phase 1 link — docs/12 |
| ☐ | Home Assistant Voice Preview Edition (hands-free "Ok Nabu") | 1+ | ~$59 | [home-assistant.io/voice-pe](https://www.home-assistant.io/voice-pe/) — docs/13 |
| ☐ | Coral USB Accelerator (Frigate AI detection) | 1 | ~$60 | [coral.ai](https://coral.ai/products/accelerator/) — chronically out of stock; check authorized distributors |
| ☐ | Synology RAM upgrade D4ES02-8G (for Frigate/voice headroom) | 1 | ~$80–100 | [synology.com](https://www.synology.com/en-us/products/DDR4) or compatible ECC SODIMM |
| ☐ | Powered USB 3 hub (NAS ports are full: dongle + UPS) | 1 | ~$20 | Amazon: search "powered USB 3.0 hub" — keep the Zigbee dongle on a direct port |

## Optional / discussed but not committed

| ✓ | Item | Est. | Notes |
|---|---|---|---|
| ☐ | Tankless water heater WiFi module (brand-specific) | ~$150–200 | Rinnai Control-R / Navien NaviLink / Rheem EcoNet — tell me the brand for the exact one |
| ☐ | Aqara FP2 mmWave presence sensor | ~$50–80 | Room-level "someone is still here" detection |
| ☐ | Inkbird BLE pool thermometer + ESP32 bridge | ~$35 | Pool temp on panels + briefing |
| ☐ | Motorized shades for slider moving panels | ~$150–250/door | SmartWings Zigbee — the alternative to filming moving panels |

---

## Budget summary

| Phase | Est. total |
|---|---|
| 1 — Security core | $150–200 |
| 2 — Cameras | $620–760 |
| 3 — Wall panels | $500–540 |
| 4 — Garage | $45 |
| 5 — Lock | $210–280 |
| **Core system (1–5)** | **~$1,525–1,825** |
| 6 — Privacy glass | $1,500–3,800 |
| 7 — Hardening (all of it) | ~$450–600 |
| **Everything** | **~$3,500–6,200** |

Ongoing cost at every stage: **$0/month**.
