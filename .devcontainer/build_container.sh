#!/bin/bash

set -euo pipefail   # good practice

# Capture UID/GID from arguments, default to 1000 if not provided
USER_UID=$(id -u)
USER_GID=$(id -g)

echo "USER_GID: $USER_GID"
echo "USER_UID: $USER_UID"
echo "USER: $USER"


# Get the absolute path of the directory where THIS script lives
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Search for devcontainer.json in the same folder as the script
JSON_PATH="$SCRIPT_DIR/devcontainer.json"

if [ ! -f "$JSON_PATH" ]; then
    echo "Error: devcontainer.json not found at $JSON_PATH"
    exit 1
fi

IMAGE_NAME=$(jq -r '.image' "$JSON_PATH")

if [ -z "$IMAGE_NAME" ] || [ "$IMAGE_NAME" == "null" ]; then
    echo "Error: Could not extract 'image' from $JSON_PATH"
    exit 1
fi

echo "Extracted IMAGE_NAME: $IMAGE_NAME"

echo "Building with USER_UID: $USER_UID and USER_GID: $USER_GID"
if [ -z "$(docker images -q "$IMAGE_NAME")" ]; then
    echo "Image '$IMAGE_NAME' not found locally. Attempting to build..."
    docker buildx build --pull --progress=plain \
        --build-arg USER_UID="${USER_UID}" \
        --build-arg USER_GID="${USER_GID}" \
        --network=host \
        --tag "$IMAGE_NAME" \
        "$(dirname "$0")"
    BUILD_STATUS=$?
    echo "Docker build exited with status: $BUILD_STATUS"
    if [ $BUILD_STATUS -ne 0 ]; then
        echo "Docker build failed!"
        exit $BUILD_STATUS
    fi
else
    echo "Image '$IMAGE_NAME' already exists locally. Skipping build."
fi
