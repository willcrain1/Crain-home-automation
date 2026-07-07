# 13 — Local Voice Control (Assist)

Talk to the house with zero cloud: "arm the alarm", "fog the front door",
"is the garage closed?" — all processed on the NAS. The docker-compose stack
now includes everything the pipeline needs:

| Container | Role | Port |
|---|---|---|
| `whisper` | Speech-to-text (faster-whisper, `base-int8` model) | 10300 |
| `piper` | Text-to-speech (already used for announcements) | 10200 |
| `openwakeword` | "Ok Nabu" wake-word detection for satellites | 10400 |

Redeploy the Container Manager project to start the new containers.

## 1. Wire the pipeline in HA

1. Settings → Devices & Services → **Wyoming Protocol** → add two entries:
   - host `<NAS_IP>`, port `10300` (Whisper / STT)
   - host `<NAS_IP>`, port `10400` (openWakeWord)
   (Piper on 10200 is already added from the announcement setup.)
2. Settings → **Voice assistants** → Add assistant:
   - Name: `Crain Voice`
   - Conversation agent: **Home Assistant** (the built-in local intent engine)
   - Speech-to-text: **faster-whisper**, Text-to-speech: **piper**,
     Wake word: **ok_nabu**
3. Same page → **Expose** tab: expose the entities voice should control
   (alarm panel, lights, garage cover, privacy glass switches, lock,
   thermostat, vacuum). Add natural **aliases** — e.g. alias
   `switch.front_door_glass_clear` as "front door glass" so "turn off the
   front door glass" fogs it.

## 2. Where you can talk to it

- **Phones (works day one):** the HA Companion app's Assist button (long-press
  home on Android to set Assist as the default assistant). Uses the local
  pipeline whenever you're on WiFi/VPN.
- **Wall tablets (Phase 3):** Fully Kiosk → Settings → Web Content →
  enable microphone access; the mic icon in the dashboard header opens
  Assist push-to-talk on the panel. Good for "arm the alarm" on the way out.
- **Hands-free wake word ("Ok Nabu" across the room):** needs a device with
  an always-listening mic. **Buy: Home Assistant Voice Preview Edition
  (~$59)** — official hardware, plugs in anywhere, pairs via the ESPHome
  integration, uses this exact pipeline. One for the kitchen is the natural
  starting point. (DIY alternative: ESP32-S3-BOX-3, ~$50, more fiddling.)

## 3. Expectations vs. the Echos

The built-in agent handles device commands and questions about states —
turn on/off, open/close, lock, arm/disarm ("arm the alarm in home mode"),
set temperature, "is the back door open?". It is not a general chatbot and
won't do music/trivia like Alexa — keep the Echos for that; this is the
private, outage-proof control channel. (A local LLM agent can be bolted on
later via Ollama, but the DS923+'s CPU isn't up to it — that would want a
small PC or a beefier NAS.)

## 4. CPU note

`base-int8` transcribes a short command in ~1–2s on the DS923+. If commands
misfire, try `small-int8` in `docker-compose.yml` (better accuracy, ~2× the
latency). If you add RAM for Frigate later, the same headroom benefits
Whisper.
