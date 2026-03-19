#!/bin/bash

# Configuration
PORTAINER_URL="http://192.168.20.2:9000"
API_TOKEN="redacted"
ENDPOINT_ID="1" # This is the "1" in your Portainer stack URL #!/1/ or 2 if you see #!/2/
STACK_ID="110"  # This is the Portainer stack "id=xxx" in your URL

# Action should be "start" or "stop"
ACTION=$1

# Execution
curl -i -X POST "$PORTAINER_URL/api/stacks/$STACK_ID/$ACTION?endpointId=$ENDPOINT_ID" \
    -H "X-API-Key: $API_TOKEN" \
    -H "Content-Type: application/json"
