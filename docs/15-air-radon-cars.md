# 15 — Air Quality, Radon, and the Cars

## Outdoor air quality — free, do in Phase 0

Add the built-in **AirNow** integration (free EPA API key from
[docs.airnowapi.org](https://docs.airnowapi.org/)) and rename its AQI entity
to `sensor.outdoor_aqi`. `packages/air_quality.yaml` then announces unhealthy
air (AQI > 100 — wildfire smoke, Saharan dust events) and warns specifically
if windows are open at the time.

## Indoor air quality (~$80–200)

Two good local-first picks, in line with the system's ethos:

| Product | ~Price | Measures | HA path |
|---|---|---|---|
| [AirGradient ONE](https://www.airgradient.com/indoor/) | ~$140–200 | PM2.5, CO2, TVOC, NOx, temp/RH | Open-source, native local HA integration — the community favorite |
| [Apollo AIR-1](https://apolloautomation.com/products/air-1) | ~$80–110 | PM2.5, CO2 (SEN55-based), VOC | ESPHome device — pairs like the ratgdo, fully local |

Rename the CO2 entity to `sensor.indoor_co2` → you get the "house is stuffy,
crack a window" nudge (which stays quiet when outdoor AQI is bad). PM/VOC
entities land on the House dashboard for trends; kitchen or main living area
is the right first location.

## Radon (~$200–300)

Florida does have real radon — roughly 1 in 5 Florida homes tests elevated in
some counties, slab construction included, so measuring is legitimate.

| Product | ~Price | HA path |
|---|---|---|
| [Airthings View Plus](https://www.airthings.com/view-plus) | ~$300 | WiFi + official cloud HA integration. Also covers PM2.5/CO2/VOC — **one device does this whole doc** |
| [Airthings Wave Plus](https://www.airthings.com/wave-plus) + ESP32 BLE proxy (~$8) | ~$230 | Bluetooth, read **fully locally** via HA's Airthings BLE integration — the ESP32 (flashed as an ESPHome Bluetooth proxy) relays it to the NAS |

Rename the radon entity to `sensor.radon`. The package alerts only on a
24-hour sustained average above the EPA 4.0 pCi/L action level — radon swings
daily, and single spikes are meaningless. Best placement: lowest lived-in
level, bedroom side of the house.

**Recommendation:** if you want both air + radon, the View Plus is one
purchase and one integration. If you want maximum local-first, Wave Plus +
ESP32 proxy plus an AirGradient ONE.

## The cars — honest verdict: skip both

- **2015 GMC Canyon:** connectivity is OnStar-era. GM's third-party API
  access requires an active OnStar/Connected Services plan (monthly fee), the
  community integrations built on it break routinely, and GM has been
  tightening access. Fails the $0/month rule for very little payoff.
- **2019 RAV4:** Toyota Connected Services works with a HACS integration
  (search "Toyota Connected Services NA"), but on a 2019 the useful remote
  features (location, remote start) sit behind the **paid** Remote Connect
  subscription after the trial; the free tier surfaces little beyond odometer
  and maintenance flags.

What you'd actually want from car integration — presence, "arrived home,
open the garage" — **your phones already provide for free** and more
reliably. If a future vehicle has factory connected services you already pay
for (or is an EV), revisit; the pattern is one HACS integration + adding the
device_tracker to the presence package.
