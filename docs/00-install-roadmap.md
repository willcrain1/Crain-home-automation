# 0 — Install Roadmap (start here)

The whole plan, ordered by **value per dollar and per hour of effort**. Each
phase is independently useful — you can stop after any phase and have a
working system. The config in this repo is written so that everything from a
phase lights up when its hardware arrives; nothing breaks while it's missing.

**Phase 0 costs nothing and delivers the majority of the daily convenience**,
because most of your devices are already smart — they've just never been
connected to each other.

| Phase | What | New spend | Effort | Docs |
|---|---|---|---|---|
| **0** | Everything you already own, connected | **$0** (+$5 Nest fee) | A weekend of software setup | 01, 02, 05, 07, 08, 09 |
| **1** | Security core: Zigbee + sensors | ~$150–200 | 1–2 evenings | 01 §2, 03 |
| **2** | Camera coverage: 4 cams + licenses | ~$620–760 | A weekend | 02 |
| **3** | Wall panels: 2 tablets | ~$500–540 | 1 day | 04 |
| **4** | Garage control: ratgdo | ~$45 | 1 evening | 07 |
| **5** | Front door lock: Yale Zigbee | ~$210–280 | 1 evening | 11 |
| **6** | Privacy glass: PDLC film | ~$1,500–3,800 | A weekend + lead time | 10 |
| **7** | Hardening & extras | à la carte | per item | 07, 08 |

Cut-over from Vector (docs/06) makes sense after **Phase 2** — sensors and
cameras are the two things Vector actually provided.

---

## Phase 0 — $0: connect what you already own (do this now)

Deploy the stack (docs/01 §1, §3–5 — **skip the Zigbee dongle section**; the
device mapping in `docker-compose.yml` stays commented out until Phase 1).
Then add integrations for hardware already in the house:

| Integration | You get on day one |
|---|---|
| **Alexa Media Player** (HACS) | **Your Echos are the announcement system** — every announcement in this repo speaks through them automatically until the wall panels exist (the announce script detects that no panels are present) |
| **Reolink** (doorbell — already purchased) | Ring events → "Someone is at the front door" on the Echos + phone push |
| **Surveillance Station** (2 free licenses) | Doorbell recording to the NAS — no license purchase needed yet |
| **Mobile App** (family phones) | Push notifications, presence, arm/disarm from anywhere |
| **Tuya** (ELEGRP switches) | Away = lights off, welcome-home lights, alarm light-blast |
| **Nest** ($5 one-time) | Eco when away, resume when home |
| **SmartHQ** (HACS — oven/dishwasher) | Dishwasher-done, oven-left-on alerts |
| **Generac** (HACS) | Outage/restore/problem alerts |
| **NUT** (UPS — already owned) | Instant outage detection + generator-failed-to-start alert |
| **Shark IQ** | Vacuums when everyone leaves |
| **Samsung TVs + Plex** | TVs off when away, movie lighting, pause on doorbell |
| **Synology DSM** | Drive-failure + storage alerts, Home Mode sync |
| **Ping / Speedtest / Met.no / NWS / Google Calendar** | Internet monitoring, weather alerts, morning briefing (via Echos) |
| **Task Scheduler + monitoring containers** | Self-deploying config, Uptime Kuma, Influx/Grafana |

The alarm panel exists from day one too — armed away/home drive all the
whole-house behavior above. Until Phase 1 it just has no sensors feeding it,
so arm/disarm is effectively your whole-house "leaving / home" switch, driven
manually from phones or automatically by presence.

**Also do now:** HA backups to a NAS shared folder + DSM snapshots on it
(docs/09) — protect the config before investing further.

## Phase 1 — ~$150–200: the security core

**Buy:** SONOFF ZBDongle-P (~$20), 8–10 Zigbee contact sensors (~$120–150).
**Do:** DSM USB-serial driver, uncomment the `devices:` block in
`docker-compose.yml`, redeploy, pair + rename sensors (docs/03).

This turns the alarm from a mode switch into a real security system: door/
window announcements, armed-mode alerts, entry delay, triggered siren over
every speaker in the house. **Highest security value per dollar in the plan.**

## Phase 2 — ~$620–760: camera coverage

**Buy:** 2× Reolink E1 Outdoor (~$130 ea), 2× Argus 4 Pro + solar (~$230 ea),
Synology 4-device license pack (~$180). **Do:** docs/02.
Continuous exterior recording with months of retention. After this phase,
**cancel Vector** (run docs/06 checklist first).

## Phase 3 — ~$500–540: wall panels

**Buy:** 2× Galaxy Tab A9+ (~$440), mounts (~$30), Fully Kiosk PLUS (~$16),
in-wall USB power (~$40). **Do:** docs/04.
Dashboards on the wall, Piper TTS takes over announcements (Echos become the
opt-in extra), doorbell camera popup, Photos screensaver. Deliberately after
Phases 1–2: the Echos + phone apps cover ~80% of this until then.

## Phase 4 — ~$45: garage control

**Buy:** ratgdo board. **Do:** docs/07 (myQ section).
Cheapest phase, outsized daily value: left-open alerts, auto-close on arm-away
and at 10:30 PM, garage on the dashboards.

## Phase 5 — ~$210–280: front door lock

**Buy:** Yale Assure Lock 2 (keyed, keypad) + Yale Zigbee module. **Do:** docs/11.
Locks when you arm, nightly lock check, locks when the house empties, jam
alerts. Needs Phase 1 (Zigbee mesh) first.

## Phase 6 — ~$1,500–3,800: privacy glass

**Buy:** PDLC film (the dominant cost — get quotes from the docs/10 vendor
list), inverters, relays, power banks. **Do:** docs/10.
The luxury phase — fog-on-demand glass with battery packs and auto-refog.
Last among the planned phases purely on cost-per-value; the automations are
already coded and waiting.

## Phase 7 — hardening & extras, à la carte

In rough value order:
1. **Water leak sensors** (~$15–20 ea, Zigbee) — under sinks, water heater,
   laundry; highest ROI purchase in home automation. Needs Phase 1.
2. **Zigbee siren** (~$30) — a real 100dB siren for the triggered state
   (uncomment the hook in `packages/alarm.yaml`).
3. **Zigbee smoke/CO** (~$25–40 ea) — closes the life-safety gap from
   dropping monitored service.
4. **Zigbee buttons** (~$12 ea) — bedside arm/disarm, garage-entry arm-away.
5. **Coral USB + RAM upgrade + Frigate** (~$100–130) — local AI person/
   vehicle/package detection on the cameras; biggest camera upgrade, biggest
   setup effort.

---

## What works when (announcement path)

| | Phase 0 | Phase 3+ |
|---|---|---|
| Announcements | All Echos (Alexa voice) | Wall panels (Piper, local) + Echos optional |
| Doorbell popup | — (announcement + push only) | Fullscreen camera on both panels |
| Arm/disarm UI | Phone app | Wall panels + phone app |
| Briefing | Echos | Front hall panel |

The switch-over is automatic: the announce script targets whichever panels
exist and falls back to the Echos when none do. No config change on tablet day
— just add the Fully Kiosk integration and rename the entities.
