# 3 — Zigbee Door/Window Sensors

SONOFF SNZB-04P (or Aqara) contact sensors on every exterior door and window,
replacing the Vector sensors (FR4).

## Pairing (per sensor)

1. Home Assistant → Settings → Devices & Services → **ZHA** → Add device.
2. Hold the sensor's pairing button ~5s until the LED blinks; it appears in HA
   within a minute.
3. **Rename immediately** (device *and* entity ID) to the convention:

   | Location | Entity ID |
   |---|---|
   | Front door | `binary_sensor.front_door_contact` |
   | Back door | `binary_sensor.back_door_contact` |
   | Garage entry door | `binary_sensor.garage_door_contact` |
   | Windows | `binary_sensor.<room>_window_contact` |

4. For each **new window sensor**, add its entity ID to the `All Windows`
   group in `homeassistant/packages/sensors.yaml`. New entry doors go in
   `Entry Doors`. The alarm and announcement automations key off those groups,
   so that's the only edit needed.

## Placement notes

- Mount the magnet on the moving part (door/sash), sensor body on the frame,
  gap ≤ 5mm when closed.
- Old Vector sensor locations are usually the right spots — the recessed
  Vector wired sensors can stay in place (dead) or be removed later.
- Zigbee range: the dongle's USB extension helps, but distant sensors may need
  a Zigbee router (any always-powered Zigbee device, e.g. a smart plug or the
  future siren) to strengthen the mesh.

## Verify

Open each door/window and watch the entity flip to `open` in HA
(Developer Tools → States). Then test the announcement: opening the front door
while `input_boolean.announcements_enabled` is on should speak "Front door
opened" on the front hall panel.

## Battery monitoring

Each sensor exposes a battery entity. Optional: create a low-battery alert
automation, or just glance at the Controls view periodically — CR2032/CR2477
cells typically last 1–2 years.
