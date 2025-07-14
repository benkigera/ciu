# ciu

A new Flutter project.

## Configuration

To run this application, you need to create a `private.json` file in the `configs/` directory with the following structure:

```json
{
    "broker": "YOUR_BROKER_ADDRESS",
    "username": "YOUR_MQTT_USERNAME",
    "key": "YOUR_AIO_KEY",
    "EXTERNAL_API_AUTH_TOKEN": "YOUR_EXTERNAL_API_AUTH_TOKEN",
    "EXTERNAL_API_BASE_URL": "YOUR_EXTERNAL_API_BASE_URL",
    "MQTT_PASSWORD": "YOUR_MQTT_PASSWORD",
    "MQTT_TOPIC_BASE": "YOUR_MQTT_TOPIC_BASE"
}
```

Replace the placeholder values with your actual credentials and API endpoints.

**Important:** This file is included in `.gitignore` and should not be committed to version control.