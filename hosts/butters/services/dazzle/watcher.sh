#!/usr/bin/env bash
set -euo pipefail

# Check for required arguments: container name and host port
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <container-name> <host-port>"
  exit 1
fi

CONTAINER_NAME="$1"
HOST_PORT="$2"

# Path to the deployment JSON file, based on container name
WATCH_FILE="/var/podman-deploy/${CONTAINER_NAME}.json"
LAST_HASH=""

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

restart_container() {
  log "Restarting container ${CONTAINER_NAME}"
  
  # Stop and remove any existing container with this name
  podman stop "${CONTAINER_NAME}" || true
  podman rm "${CONTAINER_NAME}" || true

  # Parse image name from the JSON file; it must have an "image" field
  IMAGE=$(jq -r '.image' "$WATCH_FILE")
  if [ -z "$IMAGE" ] || [ "$IMAGE" == "null" ]; then
    log "Error: 'image' field is missing or null in ${WATCH_FILE}"
    return 1
  fi

  CONTAINER_PORT=$(jq -r '.port' "$WATCH_FILE")
  if [ -z "$CONTAINER_PORT" ] || [ "$CONTAINER_PORT" == "null" ]; then
    log "Error: 'port' field is missing or null in ${WATCH_FILE}"
    return 1
  fi

  log "Starting new container with image: $IMAGE and port $CONTAINER_PORT"
  # Run the container, mapping the provided host port to container's port 80,
  # and ensure it restarts automatically.
  podman run -d --name "$CONTAINER_NAME" -p "${HOST_PORT}:${CONTAINER_PORT}" --restart=always "$IMAGE"
}

log "Watching ${WATCH_FILE} for changes..."

while true; do
  if [ -f "$WATCH_FILE" ]; then
    CURRENT_HASH=$(sha256sum "$WATCH_FILE" | awk '{print $1}')
    if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
      log "Detected change in ${WATCH_FILE}"
      LAST_HASH="$CURRENT_HASH"
      restart_container
    fi
  else
    log "Waiting for ${WATCH_FILE} to appear..."
  fi
  sleep 5
done
