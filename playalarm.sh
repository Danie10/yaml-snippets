#!/bin/bash

# Executing this script will use mpg123 to play the specified audio file
# You will need to specify your own audio file and path

audio_file="/home/danie/Alert Sounds/standard-emergency-warning-signal.mp3"

mpg123 "$audio_file"

exit 0
