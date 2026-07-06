# 5 — Remote Access (away from home, $0/month)

| Need | App | Mechanism |
|---|---|---|
| Live doorbell view / two-way talk | **Reolink** | Reolink P2P relay — built-in, free, works immediately |
| Review recorded NAS footage | **Synology DS cam** | QuickConnect (free Synology account) — see docs/02 |
| Sensor status, alarm arm/disarm, push notifications | **Home Assistant Companion** | See options below |

The first two need no extra work. For the HA Companion app, pick one:

## Option A (recommended, free): Tailscale VPN

1. Install **Tailscale** from Synology Package Center; sign in (free personal
   plan, up to 100 devices).
2. Install Tailscale on each phone, same account.
3. In the HA Companion app, set the **external URL** to the NAS's Tailscale IP
   (`http://100.x.y.z:8123`) and keep the internal URL as the LAN address with
   your home WiFi SSID listed — the app switches automatically.

Push notifications, arm/disarm, and dashboards then work anywhere with zero
open ports and zero subscriptions. Downside: the phone keeps Tailscale
connected (negligible battery cost) and other family members each need the app.

## Option B (free, more setup): Reverse proxy + DDNS

Use DSM's built-in reverse proxy (Control Panel → Login Portal → Advanced →
Reverse Proxy) with a Synology DDNS hostname + Let's Encrypt cert, forwarding
`https://<you>.synology.me:8123` → `localhost:8123`. Requires opening a port
and enabling the `http:` trusted-proxy block in
`homeassistant/configuration.yaml` (already scaffolded, commented out).

## Option C (paid — skip): Nabu Casa

$6.50/month; violates the $0/month requirement. Not used.

## Note on push notifications

Companion-app push notifications are delivered through Google/Apple push
infrastructure (via Home Assistant's free relay), so alarm and doorbell alerts
arrive on the phones regardless of VPN state. Only *viewing* dashboards or
disarming remotely requires the phone to reach HA via Option A or B.
