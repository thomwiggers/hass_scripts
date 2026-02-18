#!/usr/bin/env bash
# Synchronize blueprints (and other deployable files) to Home Assistant OS
# running as an Incus VM.
#
# Usage: ./sync_to_ha.sh [VM_NAME]
#   VM_NAME defaults to "homeassistant"

set -euo pipefail

VM="${1:-homeassistant}"
HA_CONFIG="/config"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Blueprints ────────────────────────────────────────────────────────────────
BLUEPRINT_SRC="${SCRIPT_DIR}/blueprints/automation"
BLUEPRINT_DST="${HA_CONFIG}/blueprints/automation"

if [[ ! -d "$BLUEPRINT_SRC" ]]; then
  echo "No blueprints directory found, skipping."
else
  echo "Creating blueprint directory on ${VM}..."
  incus exec "$VM" -- mkdir -p "$BLUEPRINT_DST"

  echo "Pushing blueprints..."
  for f in "${BLUEPRINT_SRC}"/*.yaml; do
    [[ -e "$f" ]] || continue
    filename="$(basename "$f")"
    echo "  → ${filename}"
    incus file push "$f" "${VM}${BLUEPRINT_DST}/${filename}"
  done
fi

echo "Done."
