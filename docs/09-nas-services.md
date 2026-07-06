# 9 — NAS Services: Auto-Deploy, Photos, Plex, Monitoring, Surveillance Sync

The DS923+ as an app platform. Redeploy the Container Manager project after
pulling these changes — three new containers (`uptime-kuma`, `influxdb`,
`grafana`) will start alongside HA and Piper.

## Task Scheduler → self-deploying config

`scripts/nas-deploy.sh` pulls this repo and restarts HA **only** when new
commits arrive *and* the config passes HA's own validation — a failed check
leaves the running system untouched and logs the reason.

DSM → Control Panel → **Task Scheduler** → Create → Scheduled Task →
User-defined script:
- User: `root` (needed for `docker`), schedule: hourly (or as you like)
- Command: `bash /volume1/docker/crain-home-automation/scripts/nas-deploy.sh`

Push a config change from anywhere; the house picks it up within the hour.
Check `scripts/deploy.log` if something doesn't land.

## Synology Photos → wall panels & Frame TVs

You already run Photos, so this is pure configuration:

- **Wall tablets as photo frames:** in Synology Photos, create a shared album
  and copy its **share link**. In Fully Kiosk on each tablet: Settings →
  Screensaver → *Screensaver Wallpaper URL* → paste the link. Idle panels now
  rotate family photos; any touch (or the doorbell popup) snaps back to the
  dashboard.
- **Frame TVs:** the Frames' art mode pulls from Samsung's app; the practical
  route is the SmartThings/Frame app pointed at photos synced from the NAS.
  For deeper automation later, the HACS `samsungtv_smart`/art-mode projects
  can push images directly — optional, fiddly, not wired in here.

## Plex → `packages/plex.yaml`

Add Integration → **Plex**, sign in — it finds the NAS server. Rename the
living-room player entity to `media_player.plex_living_room_tv`. With the
*Movie Lighting* toggle on (Controls view): pressing play after dark turns the
living room lights off; pause/stop brings them back. Plex players also show up
as media_players for future automations (e.g. pause on doorbell already covers
the TVs themselves).

## Uptime Kuma → watchdog for the watchers

Open `http://<NAS_IP>:3001`, create the admin account, then add HTTP/ping
monitors for:

| Monitor | Target |
|---|---|
| Home Assistant | `http://<NAS_IP>:8123` |
| Piper TTS | TCP `<NAS_IP>:10200` |
| Surveillance Station | `http://<NAS_IP>:5000` |
| Each camera + doorbell | ping their static IPs |
| Internet | ping `8.8.8.8` |

Set up a notification channel (its HA webhook option, email, or dozens of
others). Uptime Kuma catches the failure HA can't report: HA itself being down.

## InfluxDB + Grafana → long-term history

HA's built-in recorder keeps ~10 days. Influx keeps years — NAS temps,
internet speeds, thermostat cycles, generator runs, UPS events.

1. Open `http://<NAS_IP>:8086` → first-run setup: user, org **`crain-home`**,
   bucket **`homeassistant`**. Copy the API token it generates
   (or make one under API Tokens).
2. Put the token in `homeassistant/secrets.yaml` as `influxdb_token`.
3. Uncomment the `influxdb:` block in `homeassistant/configuration.yaml`,
   restart HA. Errors, if any, show in Settings → System → Logs.
4. Open Grafana at `http://<NAS_IP>:3000` (admin/admin, change it), add an
   InfluxDB data source (Flux, URL `http://<NAS_IP>:8086`, your org/bucket/
   token), and build dashboards — start with internet speed over time and
   NAS drive temps.

## Surveillance Station sync → `packages/surveillance.yaml`

Uses the same **Synology DSM** integration you set up for NAS health
(docs/08). Two extras to wire up:

- **Home Mode sync:** rename the integration's Home Mode switch to
  `switch.nas_home_mode`. The alarm now drives it — disarm and Surveillance
  Station goes to Home Mode (recording continues, DS cam notifications hush);
  arm (home or away) and full notifications return. Configure exactly what
  each mode does in Surveillance Station → Home Mode.
- **Camera entities:** the DSM integration creates a `camera.*` entity per
  Surveillance Station camera, with motion sensors from SS's detection.
  These are an independent path to the same streams — if a Reolink's native
  events ever misbehave over WiFi, swap the affected dashboard card or
  automation trigger to the SS-provided entity without touching the camera.

## Port map (all LAN-only)

| Service | Port |
|---|---|
| Home Assistant | 8123 |
| Piper TTS | 10200 |
| Uptime Kuma | 3001 |
| InfluxDB | 8086 |
| Grafana | 3000 |
| DSM / Surveillance Station | 5000/5001 |
