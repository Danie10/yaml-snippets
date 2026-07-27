#!/bin/bash

# Define the API key, secret, and URL
API_KEY="your key here"
API_SECRET="API secret here"
# Remember to update your own IP address below
URL="https://192.168.1.1/api/diagnostics/system/systemTemperature"

# Run the curl command and capture the output
TEMPERATURE=$(curl -s -k -u "$API_KEY:$API_SECRET" "$URL" | grep -oP '"device":"dev.cpu.0.temperature".*?"temperature":"\K[^"]+')

# Check if the temperature value was extracted successfully
if [[ -n "$TEMPERATURE" ]]; then
    # Round the temperature to an integer using awk
    ROUNDED_TEMPERATURE=$(echo "$TEMPERATURE" | awk '{printf "%d\n", $1 + 0.5}')

    # Output the rounded integer temperature value
    echo "$ROUNDED_TEMPERATURE"
else
    # Handle the case where the temperature value couldn't be extracted
    echo "Error: Could not retrieve temperature."
    exit 1 #Exit with an error code.
fi
