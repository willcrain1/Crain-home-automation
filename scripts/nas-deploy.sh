#!/bin/sh
# Auto-deploy: pull the latest config from git and restart Home Assistant
# only if something changed AND the new config passes HA's own check.
#
# Run from DSM Task Scheduler (docs/09-nas-services.md):
#   Control Panel → Task Scheduler → Create → Scheduled Task → User-defined
#   script, user: root, schedule: e.g. hourly, command:
#     bash /volume1/docker/crain-home-automation/scripts/nas-deploy.sh
#
# Log output lands in deploy.log next to this script.

set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$REPO_DIR/scripts/deploy.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"
}

cd "$REPO_DIR"

OLD_REV=$(git rev-parse HEAD)
if ! git pull --ff-only >> "$LOG" 2>&1; then
    log "ERROR: git pull failed"
    exit 1
fi
NEW_REV=$(git rev-parse HEAD)

if [ "$OLD_REV" = "$NEW_REV" ]; then
    # Nothing new — stay quiet and leave HA alone.
    exit 0
fi

log "updated $OLD_REV -> $NEW_REV, validating config"

if ! docker exec homeassistant python -m homeassistant --script check_config -c /config >> "$LOG" 2>&1; then
    log "ERROR: config check FAILED — HA not restarted, still running old config"
    exit 1
fi

log "config OK, restarting Home Assistant"
docker restart homeassistant >> "$LOG" 2>&1
log "deploy complete"
