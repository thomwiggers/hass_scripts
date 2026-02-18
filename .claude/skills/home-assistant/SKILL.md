---
name: home-assistant
description: Use when interacting with the Home Assistant instance - querying entity states, calling services, controlling devices (lights, switches, covers, climate), or automating tasks via the REST API.
---

# Home Assistant API Access

## Connection Details

- **URL:** `https://hass.rded.nl`
- **API key file:** `/Users/thom/hass_scripts/apikey`
- **Auth:** Bearer token in `Authorization` header

```bash
TOKEN=$(cat /Users/thom/hass_scripts/apikey)
curl -s -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" https://hass.rded.nl/api/
```

## Quick Reference

| Task | Method | Endpoint |
|------|--------|----------|
| Check API | GET | `/api/` |
| All states | GET | `/api/states` |
| One entity | GET | `/api/states/<entity_id>` |
| Call service | POST | `/api/services/<domain>/<service>` |
| Fire event | POST | `/api/events/<event_type>` |
| Render template | POST | `/api/template` |
| Error log | GET | `/api/error_log` |

## Common Operations

### Get all entities of a domain
```bash
TOKEN=$(cat /Users/thom/hass_scripts/apikey)
curl -s -H "Authorization: Bearer $TOKEN" https://hass.rded.nl/api/states \
  | python3 -c "
import json, sys
states = json.load(sys.stdin)
for s in states:
    if s['entity_id'].startswith('light.'):
        print(s['entity_id'], s['state'], s['attributes'].get('friendly_name',''))
"
```

### Get a single entity state
```bash
TOKEN=$(cat /Users/thom/hass_scripts/apikey)
curl -s -H "Authorization: Bearer $TOKEN" \
  https://hass.rded.nl/api/states/sensor.some_sensor | python3 -m json.tool
```

### Call a service (e.g. turn off a light)
```bash
TOKEN=$(cat /Users/thom/hass_scripts/apikey)
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "light.living_room"}' \
  https://hass.rded.nl/api/services/light/turn_off
```

### Common service calls

| Action | Domain/Service | Key payload fields |
|--------|---------------|-------------------|
| Turn light on/off | `light/turn_on`, `light/turn_off` | `entity_id`, `brightness` (0-255), `color_temp` |
| Toggle switch | `switch/toggle` | `entity_id` |
| Run automation | `automation/trigger` | `entity_id` |
| Open/close cover | `cover/open_cover`, `cover/close_cover` | `entity_id` |
| Set climate temp | `climate/set_temperature` | `entity_id`, `temperature` |
| Activate scene | `scene/turn_on` | `entity_id` |
| Run script | `script/turn_on` | `entity_id` |

### Render a template
```bash
TOKEN=$(cat /Users/thom/hass_scripts/apikey)
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"template": "{{ states(\"sensor.some_sensor\") }}"}' \
  https://hass.rded.nl/api/template
```

## Entity Overview (1275 total)

Key domains: `sensor` (536), `binary_sensor` (127), `switch` (125), `button` (103), `scene` (86), `select` (74), `update` (51), `light` (40), `device_tracker` (39), `automation` (20), `number` (24), `cover` (7), `media_player` (6), `person` (2), `vacuum` (2), `camera` (3)

Notable integrations: ZHA (Zigbee), Shelly, HomeWizard, Hue, Netatmo, KIA UVO, Bambu Lab, Home Connect, Overkiz, Matter, UniFi, SAJ Modbus, Dreame Vacuum, Google Assistant

## Tips

- **Temperature sensors:** May be `sensor.*temperature*` or `attributes.current_temperature` on `climate.*` entities
- **Service response:** Returns array of affected entity states - check `state` field to confirm action
- **Discovery:** When entity ID is unknown, fetch `/api/states` and filter by domain prefix and `friendly_name`
- **SSL:** Valid cert on `hass.rded.nl`, no `-k` flag needed
