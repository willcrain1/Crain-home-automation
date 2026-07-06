# 8 — Free Software Integrations (no new hardware)

Six additions that cost nothing and need no purchases. Each has a package in
`homeassistant/packages/`; this doc covers the one-time UI setup for each.

## Presence detection → `packages/presence.yaml`

1. Each family member installs the **HA Companion app** (they likely already
   have it for notifications) and signs in with their own HA user.
2. Settings → People → create a **Person** per family member and attach their
   phone's `device_tracker`.
3. Done — `zone.home` now counts occupants.

You get: a push reminder when everyone has left but the alarm is disarmed —
or full **auto-arm** if you flip that toggle on the Controls view — plus
optional arrival announcements. The auto-arm toggle ships **off**; run the
reminder mode for a week or two to build trust in phone presence (a phone that
dies or drops off WiFi looks like a departure) before enabling it.

## NAS health → `packages/nas_health.yaml`

Add Integration → **Synology DSM** → host = NAS IP. Create a dedicated
non-admin DSM user for it (with 2FA off for that account). Then map the two
template sensors at the top of the package to the real volume/drive entities
it creates. You get: a critical alert if a drive leaves "normal" (the mirror
buys you time, but only if you know), and a warning at 85% volume usage.

## Weather + severe alerts → `packages/weather.yaml`

- Forecast: the default **Met.no** integration ships with HA
  (`weather.forecast_home`) — set your home coordinates in Settings → System →
  General and it just works.
- Severe alerts: HACS → **"NWS Alerts"** → configure with your county/zone ID
  from [alerts.weather.gov](https://alerts.weather.gov) → `sensor.nws_alerts`.

You get: tornado/severe-thunderstorm/etc. warnings announced on the panels and
pushed, and a freeze-warning announcement at 8 PM when tonight's low ≤ 32°F
(pool equipment, hose bibs).

## Google Calendar + morning briefing → `packages/briefing.yaml`

Add Integration → **Google Calendar** (OAuth flow; free "device" credentials —
follow the HA docs page). Rename the entity referenced in the package
(`calendar.family`) to match yours, or rename yours to match.

You get: at the time set on the Controls view (default 7:00 AM, only when
someone's home), the front hall panel speaks today's weather, calendar events,
and any open-house flags (garage/doors/windows). Put trash day on the calendar
and it's your trash reminder too.

## Internet speed logging → `packages/speedtest.yaml`

Add Integration → **Speedtest.net**. Set the *Internet Speed Floor* on the
Controls view to ~80% of the plan speed you pay AT&T for. You get: a push
whenever a test lands under the floor, and a download-speed history graph
(tap the sensor on the House view) — actual evidence for support calls.

## Battery watchdog → `packages/battery_watchdog.yaml`

Nothing to configure. Every entity in the system reporting
`device_class: battery` — Zigbee sensors, wall tablets, the vacuum, anything
added later — is swept every Sunday at 10 AM; anything under 20% goes into one
summary push and a short panel announcement.

## Music Assistant (staged for Sonos)

A commented-out `music-assistant` service sits in `docker-compose.yml`.
When the Sonos speakers arrive, uncomment it, redeploy the project, and add
the **Music Assistant** integration — one library and one "play anywhere"
control surface across Sonos, the Echos, and the Frame TVs.
