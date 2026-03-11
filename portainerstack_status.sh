#!/bin/bash

# Configuration
PORTAINER_URL="http://192.168.20.2:9000"
API_TOKEN="redacted"
STACK_ID="110"

# Fetch Stack Info
RESPONSE=$(curl -s -X GET "$PORTAINER_URL/api/stacks/$STACK_ID" \
    -H "X-API-Key: $API_TOKEN")

# Parse Status using grep/sed (simple) or jq (cleaner if you have it installed)
STATUS=$(echo $RESPONSE | grep -oP '"Status":\s*\K\d+')

if [ "$STATUS" == "1" ]; then
    echo "STARTED"
    # Do NOT exit 1 here
elif [ "$STATUS" == "2" ]; then
    echo "STOPPED"
    # Do NOT exit 2 here
else
    echo "UNKNOWN"
fi

# ALWAYS exit 0 so Companion accepts the result
exit 0
