# An automated script file to update the docker containers
# Create in home directory with: 'nano update_stack.sh'
# Put these contents in that file:

#!/bin/bash

# Move to the monitoring directory or exit if does not exist
cd ~/monitoring || { echo "Directory not found"; exit 1; }

# Pull the latest images
docker compose pull

# Restart containers with the new images
docker compose up -d

# Clean up unused images
docker image prune -f

echo "Update complete!"

# Save it and make executable with: 'chmod +x update_stack.sh'
# Run any time with: './update_stack.sh'
