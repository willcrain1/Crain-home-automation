# 14 — Master Shopping List

Everything left to buy, grouped by install phase (docs/00 roadmap), with the
feature each item unlocks. Prices are July 2026 estimates — check current
pricing. Manufacturer links given where they're stable; most items are also
on Amazon, often cheaper.

**Phase 0 needs nothing** — only the one-time $5
[Google Device Access fee](https://developers.google.com/nest/device-access/registration)
for the Nest integration (unlocks: Eco-when-away, resume-on-return, AC-failure
alert, thermostat on wall panels).

---

## Phase 1 — Security core (~$150–200)

| ✓ | Item | Qty | Est. | Feature it unlocks | Link |
|---|---|---|---|---|---|
| ☐ | SONOFF ZBDongle-P (Zigbee coordinator) | 1 | ~$20 | The Zigbee mesh itself — required by every sensor, the lock, siren, buttons, and leak sensors | [itead.cc](https://itead.cc/product/sonoff-zigbee-3-0-usb-dongle-plus/) |
| ☐ | SONOFF SNZB-04P contact sensors (doors + windows) | 8–10 | ~$13 ea | The alarm: "front door opened" announcements, armed-mode alerts, entry delay, triggered siren — replaces Vector's sensors | [itead.cc](https://itead.cc/product/sonoff-zigbee-door-window-sensor-snzb-04p/) — Aqara Door & Window is the alternative |

## Phase 2 — Cameras (~$620–760)

| ✓ | Item | Qty | Est. | Feature it unlocks | Link |
|---|---|---|---|---|---|
| ☐ | Reolink E1 Outdoor (plug-in PTZ) | 2 | ~$120–140 ea | Continuous exterior recording (porch, patio) to the NAS; live views on panels/phones | [reolink.com](https://reolink.com/us/product/e1-outdoor/) |
| ☐ | Reolink Argus 4 Pro + solar panel | 2 | ~$200–230 ea | Wire-free coverage (driveway, perimeter) — no outlet needed | [reolink.com](https://reolink.com/us/product/argus-4-pro/) |
| ☐ | Synology Surveillance Device License Pack, 4 licenses | 1 | ~$180 | Lets Surveillance Station record all 5 devices (2 free + these 4 = 1 spare slot for a future camera) | [synology.com](https://www.synology.com/en-us/surveillance/license) — one-time |

**After this phase: cancel Vector** (docs/06 checklist first).

## Phase 3 — Wall panels (~$500–540)

| ✓ | Item | Qty | Est. | Feature it unlocks | Link |
|---|---|---|---|---|---|
| ☐ | Samsung Galaxy Tab A9+ (11", WiFi) | 2 | ~$200–220 ea | The wall panels: dashboards, alarm keypad, camera views, local Piper announcements (Echos become optional), doorbell popup, photo-frame screensaver, voice push-to-talk | [samsung.com](https://www.samsung.com/us/tablets/galaxy-tab-a9-plus/) — sales are frequent |
| ☐ | Fully Kiosk Browser PLUS license | 2 | ~$8 ea | Kiosk lockdown + the remote API HA uses for TTS audio, screen wake, and the doorbell popup | [fully-kiosk.com](https://www.fully-kiosk.com/en/#licenses) |
| ☐ | Universal tablet wall mount (non-VESA) | 2 | ~$15–20 ea | Mounting at the old Vector panel locations | Amazon: search "universal tablet wall mount 11 inch" |
| ☐ | In-wall USB-C power kit or slim 10ft USB-C cable + adapter | 2 | ~$15–20 ea | Permanent low-voltage power through the existing wall openings — no electrician | Amazon: search "in-wall tablet charging kit USB-C" |

## Phase 4 — Garage (~$45)

| ✓ | Item | Qty | Est. | Feature it unlocks | Link |
|---|---|---|---|---|---|
| ☐ | ratgdo (ESPHome version for your opener model) | 1 | ~$45 | Local garage door control (myQ's API is closed): left-open reminders, auto-close on arm-away and at 10:30 PM, hurricane-mode close, garage on dashboards | [ratgdo.com](https://ratgdo.com) or [konnected.io](https://konnected.io/products/ratgdo) — check opener compatibility before ordering |

## Phase 5 — Front door lock (~$210–280)

| ✓ | Item | Qty | Est. | Feature it unlocks | Link |
|---|---|---|---|---|---|
| ☐ | Yale Assure Lock 2 — **keyed** keypad deadbolt | 1 | ~$160–230 | Keypad entry + auto-lock on arm, nightly lock check, lock-when-house-empties, jam alerts, guest codes | [shopyalehome.com](https://shopyalehome.com/collections/assure-lock-2) — measure the glass door's cross-bore first (docs/11) |
| ☐ | Yale Zigbee Smart Module | 1 | ~$50 | Connects the lock to the existing Zigbee mesh — local, no hub, no cloud | [shopyalehome.com](https://shopyalehome.com/products/yale-zigbee-smart-module) — Zigbee, not WiFi/Z-Wave |

## Phase 6 — Privacy glass (~$1,500–3,800, film dominates)

All items together unlock: button-press "fog" on the glass front door and
sliders, auto-fog when arming / on alarm / on doorbell ring, auto-refog
battery saver, hurricane-mode fog. Full detail + wiring in docs/10.
Per-zone quantities: front door = 1 zone, back sliders = 1–2 zones.

| ✓ | Item | Qty | Est. | Role in the build | Link |
|---|---|---|---|---|---|
| ☐ | PDLC self-adhesive film, cut to size, white | ~40–60 sq ft | $29–90/sq ft | The switchable glass itself — fogged with no power, clear when energized | [InvisiShade](https://invisishade.com/) (premium) · [Smart Tint](https://shop.smarttint.com/) · [pdlcglass.com](https://www.pdlcglass.com/products/self-adhesive-pdlc-film/) (budget) — get quotes from all three |
| ☐ | 12V DC → 60–70V AC PDLC inverter | 1/zone | ~$25–40 | Drives the film from battery power (must be AC-output, PDLC-specific) | Ask the film vendor for their matched 12V driver, or Amazon/eBay "PDLC film inverter 12V" |
| ☐ | ZY12PDN USB-C PD trigger board, set to 12V | 1/zone | ~$10 | Lets a standard power bank feed the 12V inverter | Amazon/AliExpress: search "ZY12PDN" |
| ☐ | ~100Wh USB-C PD power bank **with 12V output listed** | 2/zone | ~$60–90 ea | The swappable battery — one on the door, one charging (~1 week/swap front door) | Any reputable brand — verify 12V in the PD spec table (docs/10) |
| ☐ | Shelly Plus 1 (12V DC) or ESP32 + relay + INA219 | 1/zone | ~$15–25 | HA's on/off control of each zone; ESP32 route adds battery % for swap alerts | [shelly.com](https://us.shelly.com/products/shelly-plus-1) — docs/10 |
| ☐ | Slim ABS project enclosure + velcro | 1/zone | ~$15 | Houses inverter/relay/battery on the door — nothing crosses the door gap | Amazon: search "ABS project enclosure" |

## Phase 7 — Hardening & extras (à la carte, value order)

| ✓ | Item | Qty | Est. | Feature it unlocks | Link |
|---|---|---|---|---|---|
| ☐ | SONOFF SNZB-05P water leak sensors | 5 | ~$15 ea | Leak → critical announcement + push naming the location (kitchen, dishwasher, water heater, laundry, master bath) | [itead.cc](https://itead.cc/product/sonoff-zigbee-water-leak-sensor-snzb-05p/) |
| ☐ | Zigbee water valve actuator (clamp-on, 1/2"–1") | 1 | ~$80–150 | Auto water-main shutoff when a leak is detected + monthly valve exercise | Amazon: search "Zigbee smart water valve actuator" — docs/12 |
| ☐ | Zigbee siren (Heiman HS2WD or similar) | 1 | ~$30 | Real 100dB siren when the alarm triggers (today it's voice-only) — uncomment the hook in `packages/alarm.yaml` | Amazon: search "Heiman Zigbee siren" |
| ☐ | Zigbee smoke/CO detectors (Heiman HS1SA or listener) | 2–4 | ~$25–40 ea | Smoke/CO alerts to phones when away + panel announcements — closes the life-safety gap from dropping monitored service | Amazon: search "Heiman Zigbee smoke detector" |
| ☐ | SONOFF SNZB-01P buttons | 2 | ~$11 ea | Bedside arm-home/disarm without a panel; garage-entry "arm away + close everything" button | [itead.cc](https://itead.cc/product/sonoff-zigbee-wireless-switch-snzb-01p/) |
| ☐ | Mailbox contact sensor (one more SNZB-04P) | 1 | ~$13 | "Mail has arrived" announcement (daytime, cooldown) | same as Phase 1 link — docs/12 |
| ☐ | Home Assistant Voice Preview Edition | 1+ | ~$59 | Hands-free "Ok Nabu" voice control — arm/disarm, fog glass, ask states — fully local (pipeline containers already running) | [home-assistant.io/voice-pe](https://www.home-assistant.io/voice-pe/) — docs/13 |
| ☐ | Coral USB Accelerator | 1 | ~$60 | Frigate AI on the cameras: "person in the driveway" / package detection instead of raw motion, with snapshot pushes | [coral.ai](https://coral.ai/products/accelerator/) — chronically out of stock; use authorized distributors |
| ☐ | Synology RAM upgrade D4ES02-8G | 1 | ~$80–100 | Headroom for Frigate + snappier Whisper voice responses | [synology.com](https://www.synology.com/en-us/products/DDR4) or compatible ECC SODIMM |
| ☐ | Powered USB 3 hub | 1 | ~$20 | Frees NAS USB ports (dongle + UPS already fill both) for the Coral | Amazon: search "powered USB 3.0 hub" — keep the Zigbee dongle on a direct port |

## Optional / discussed but not committed

| ✓ | Item | Est. | Feature it would unlock |
|---|---|---|---|
| ☐ | Tankless water heater WiFi module (Rinnai Control-R / Navien NaviLink / Rheem EcoNet — brand-specific) | ~$150–200 | Remote temp control, away-mode setpoint dip, error-code push alerts |
| ☐ | Aqara FP2 mmWave presence sensor | ~$50–80 | Room-level still-person detection — lights that never flick off on you, smarter goodnight checks |
| ☐ | Inkbird BLE pool thermometer + ESP32 bridge | ~$35 | Pool temperature on the panels and in the morning briefing |
| ☐ | Motorized shades (SmartWings Zigbee) for slider moving panels | ~$150–250/door | Months-per-charge blackout alternative to filming the moving slider panels |

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
