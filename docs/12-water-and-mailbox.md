# 12 — Water Protection & Mailbox: What to Buy and Do

Packages already in the repo (`water.yaml`, `mailbox.yaml`) — they no-op
until this hardware pairs. Both need the Zigbee mesh (roadmap Phase 1).

## Water protection (~$200–300 total)

**Buy:**

| Item | Qty | Est. | Notes |
|---|---|---|---|
| Zigbee water leak sensors (SONOFF SNZB-05P or Aqara Water Leak) | 5 | ~$15–20 ea | Kitchen sink, dishwasher, water heater, laundry, master bath |
| Motorized ball-valve actuator, Zigbee or WiFi | 1 | ~$80–150 | Clamps onto the existing main shutoff handle — no plumbing cut. Look for "Zigbee water valve actuator" (Tuya-style, fits 1/2"–1" valves); Zigbee joins the mesh directly, WiFi/Tuya versions work via the Tuya integration |

Big-brand alternative: Moen Flo (~$400–500, professionally plumbed inline,
adds flow metering). The clamp-on actuator + sensors covers the core risk at
half the price with no plumber.

**Do:**

1. Pair each leak sensor via ZHA; rename to `binary_sensor.<location>_leak`
   and confirm each is listed in the `Leak Sensors` group in
   `packages/water.yaml` (edit to match your actual locations).
2. Place them where water pools first: under the kitchen sink trap, beside
   the dishwasher, in the water heater drip pan, behind the washing machine,
   under the master bath vanity.
3. Mount the actuator on the main shutoff; pair; rename to `valve.water_main`.
   If it appears as a `switch` instead of a `valve`, change the two
   `valve.close_valve` / `valve.open_valve` calls in the package to
   `switch.turn_off` / `switch.turn_on`.
4. Test: touch a damp cloth to a sensor's contacts — announcement + push,
   and (with *Auto Water Shutoff on Leak* toggled on) the main closes.
5. Leave the monthly valve-exercise automation alone — it closes and reopens
   the valve for 2 minutes on the 1st at noon so it never seizes.

**What you get:** leak → critical announcement + push naming the location,
auto main shutoff (toggleable), monthly valve exercise, and the sensors join
the weekly battery watchdog automatically.

## Mailbox (~$15)

**Buy:** one more SONOFF SNZB-04P contact sensor (same model as the doors).

**Do:**

1. Mount the sensor body inside the mailbox roof, magnet on the door/flap,
   gap ≤ 5mm closed. If the mailbox is metal, mount both pieces as close to
   the opening as possible — metal boxes attenuate Zigbee; if it won't reach,
   a smart plug (Zigbee router) in the garage usually bridges the gap.
2. Pair via ZHA, rename to `binary_sensor.mailbox_contact`.

**What you get:** "Mail has arrived" announcement (daytime only, 2-hour
cooldown so collecting the mail doesn't re-announce).
