#!/bin/bash

# Run `wpctl status` to check what the name of the source is to test
# In my case it showed under Audio/Sources: 60. Webcam C310 Mono
# Change the status= line below to reflect your microphone source name
# Volume: 0.40 [MUTED] indicates the source is muted, [vol: 0.35] would mean it is at 35%

# Get the volume status of device ID 60
mic_muted=$(wpctl get-volume 60)

# Check if the output contains the string "[MUTED]"
if echo "$mic_muted" | grep -q "[MUTED]"; then
    echo "true" # Microphone is muted
    exit 0      # Return true (0)
else
    echo "false" # Microphone is not muted
    exit 1       # Return false (1)
fi
