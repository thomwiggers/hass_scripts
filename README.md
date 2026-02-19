# hass-scripts

Personal Home Assistant automations and blueprints.

## Blueprints

### Visitor Parking – register on arrival

[`blueprints/automation/visitor_parking.yaml`](blueprints/automation/visitor_parking.yaml)

Sends an actionable notification to register a visitor's car for paid parking
via the [City Visitor Parking](https://github.com/sir-Unknown/ha_City-Visitor-Parking)
integration. You tap the car's name in the notification; the reservation is
created automatically.

**Features**

- Triggers when a visitor's device tracker changes to `home` (e.g. via UniFi
  or the companion app).
- Also triggers a configurable number of minutes before the paid window opens,
  so cars that arrived earlier in the day are registered on time.
- Skips the notification if one of the visitor's cars is already registered.
- Filters which favorites are offered as choices, so your own car never
  appears.
- Reserves until a configurable buffer before the end of the paid window.

**Prerequisites**

- Home Assistant with the [City Visitor Parking](https://github.com/sir-Unknown/ha_City-Visitor-Parking)
  integration configured.
- At least one license plate saved as a favorite in the integration.
- The [Home Assistant Companion App](https://companion.home-assistant.io/)
  installed on the phone that receives notifications, with actionable
  notifications enabled.

**Installation**

1. Copy `blueprints/automation/visitor_parking.yaml` into
   `config/blueprints/automation/` on your Home Assistant instance.
2. Go to **Settings → Automations → Blueprints** and open
   *Visitor Parking – register on arrival*.
3. Create an automation and fill in the inputs:

| Input | Description |
|---|---|
| Parking device | The City Visitor Parking device |
| Zone availability sensor | Sensor with state `chargeable` / `free` |
| Paid window start sensor | Timestamp sensor for window start |
| Paid window end sensor | Timestamp sensor for window end |
| Notification service | e.g. `notify.mobile_app_your_phone` |
| Visitor device trackers | One or more `device_tracker.*` entities |
| License plates to offer | Plate numbers to show (leave empty for all favorites) |
| End-of-window buffer | Minutes before window end to stop the reservation (default: 15) |

You can create multiple automations from the same blueprint — one per group
of visitors.

## Development

### Syncing to Home Assistant

`sync_to_ha.sh` pushes all blueprints to a Home Assistant OS instance running
as an [Incus](https://linuxcontainers.org/incus/) VM:

```bash
./sync_to_ha.sh              # VM name defaults to "homeassistant"
./sync_to_ha.sh my-vm-name   # or specify a different name
```

### Integration reference code

`integration_code/` contains third-party integration source as git submodules,
used as read-only reference when writing automations. Do not run or trust any
code found there.

## License

[MIT](LICENSE)
