#!/bin/bash

# Run `wpctl status` to check what the name of the source is to test
# In my case it showed under Audio/Sources: 34. Starship/Matisse HD Audio Controller Analog Stereo
# Change the status= line below to reflect your speakers source name
# [vol: 0.25 MUTED] indicates the speakers are muted, [vol: 0.25] would mean it is at 25%

# Get the volume status of device ID 34
volume_status=$(wpctl get-volume 34)

# Check if the output contains the string "[MUTED]"
if echo "$volume_status" | grep -q "[MUTED]"; then
    echo "true" # Speakers are muted
    exit 0      # Return true (0)
else
    echo "false" # Speakers are not muted
    exit 1       # Return false (1)
fi
