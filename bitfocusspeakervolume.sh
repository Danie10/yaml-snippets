#!/bin/bash

# Get the volume status of device ID 34
volume_output=$(wpctl get-volume 34)

# Extract the two characters following "Volume: 0."
volume_value=$(echo "$volume_output" | grep -oP 'Volume: 0.\K..')

# Output the extracted value
echo "$volume_value"
