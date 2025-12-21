#!/bin/bash

# Script returns true if Kdenlive window is open, or false if it is closed
# NOTE: This may only owrk under X11 and not Wayland
# Window title to search for (replace with your desired title)
TARGET_WINDOW_TITLE=" Kdenlive$"

# Use wmctrl to search for windows with matching title
WINDOW_LIST=$(wmctrl -l | grep "$TARGET_WINDOW_TITLE")

# Check if the grep command found any matches
if [ -n "$WINDOW_LIST" ]; then
  # Window found - return true (exit code 0)
  echo "true"
  exit 0
else
  # Window not found - return false (exit code 1)
  echo "false"
  exit 1
fi
