# 6 — Vector Decommission Checklist

Cancel Vector monitoring **only after everything below passes**. Remember:
this system is **self-monitored** — push notifications to your phones, no
central station, no police/fire dispatch service.

## Go-live checklist

### Video
- [ ] All 5 devices recording in Surveillance Station (4 continuous, doorbell on events)
- [ ] Retention policy set; RAID confirmed SHR/RAID 1 (mirrored)
- [ ] Doorbell wired to the existing transformer (continuous power, not battery-only)
- [ ] Reolink app live view + two-way talk works **on cellular** (WiFi off)
- [ ] DS cam plays back recorded footage **on cellular**

### Sensors & alarm
- [ ] Every exterior door + window sensor paired, named, and in the right group
      (`packages/sensors.yaml`)
- [ ] Each sensor physically tested: open → HA shows `open`
- [ ] Armed Away: opening the front door starts the entry-delay announcement,
      and triggers the alarm (siren announcements + push) if not disarmed in 30s
- [ ] Armed Home: opening a window produces immediate TTS alert + push
- [ ] Disarm from wall panel and from phone both work

### Announcements & panels
- [ ] "Front door opened" / "Garage door opened" spoken on the panels
- [ ] Bedroom announcements toggle silences the bedroom panel
- [ ] Doorbell ring → announcement + fullscreen camera popup + return to dashboard
- [ ] Push notification received on all phones for doorbell + alarm events

### Resilience
- [ ] Pull the internet (unplug WAN): recording, announcements, arm/disarm,
      and panels all keep working on LAN (NFR3)
- [ ] Reboot the NAS: containers auto-start, dongle re-attaches, HA comes back
      without manual steps
- [ ] Set up HA backups (Settings → System → Backups) to a NAS shared folder

### Cutover
- [ ] Run both systems in parallel for ~2 weeks
- [ ] Cancel Vector monitoring contract
- [ ] Remove/retire Vector panel & keypads (wall openings reused for tablet
      USB power); old recessed sensors can stay in place, dead
