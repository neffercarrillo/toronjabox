#!/bin/bash

# Get the username of the current host machine
HOST_USER=$(whoami)

echo "🍊 Building toronjabox for user: $HOST_USER..."

# Build the image, passing the host username into the Dockerfile
podman build \
    --build-arg DEV_USER="$HOST_USER" \
    -t toronjabox .

echo "🍊 Launching toronjabox..."

# Run toronjabox with clean, isolated project volume mounts
podman run -it --rm \
    --name running-toronjabox \
    --hostname toronjabox \
    --userns=keep-id \
    -v "$(pwd):/home/$HOST_USER/project:Z" \
    -v "$SSH_AUTH_SOCK:/run/ssh-agent.sock:Z" \
    -e SSH_AUTH_SOCK=/run/ssh-agent.sock \
    toronjabox
