#!/bin/bash

# Get the username of the current host machine
HOST_USER="user"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
CONTAINER_NAME="running-toronjabox-$TIMESTAMP"

echo "🍊 Building toronjabox for user: $HOST_USER..."

# Build the image, passing the host username into the Dockerfile
# podman build \
#     --build-arg DEV_USER="$HOST_USER" \
#     -t toronjabox .
podman pull ghcr.io/neffercarrillo/toronjabox:latest

echo "🍊 Launching $CONTAINER_NAME..."

# Run toronjabox with clean, isolated project volume mounts
podman run -it --rm \
    --name $CONTAINER_NAME \
    --hostname toronjabox \
    --userns=keep-id \
    -v "$(pwd):/home/$HOST_USER/project:Z" \
    -v "$SSH_AUTH_SOCK:/run/ssh-agent.sock:Z" \
    -e SSH_AUTH_SOCK=/run/ssh-agent.sock \
    toronjabox
