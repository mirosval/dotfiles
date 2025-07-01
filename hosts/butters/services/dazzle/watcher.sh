#!/usr/bin/env bash
set -euo pipefail

# === USAGE ===
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <image> <container-name> <port-mapping>"
    echo "Example: $0 nginx:latest my-nginx 8080:80"
    exit 1
fi

IMAGE="$1"
CONTAINER="$2"
PORT="$3"

# === CHECK DEPENDENCIES ===
command -v podman >/dev/null || { echo "podman not found"; exit 1; }
command -v skopeo >/dev/null || { echo "skopeo not found"; exit 1; }

# === GET DIGESTS ===
REMOTE_DIGEST=$(skopeo inspect "docker://${IMAGE}" --format '{{.Digest}}')
LOCAL_DIGEST=$(podman image inspect "$IMAGE" --format '{{.Digest}}' 2>/dev/null || echo "")

# === IF NO LOCAL IMAGE OR DIGESTS DIFFER, UPDATE ===
if [[ -z "$LOCAL_DIGEST" || "$REMOTE_DIGEST" != "$LOCAL_DIGEST" ]]; then
    echo "Updating container '$CONTAINER' with new image: $IMAGE"

    OLD_IMAGE_ID=$(podman image inspect "$IMAGE" --format '{{.Id}}' 2>/dev/null || echo "")

    podman pull "$IMAGE"
    podman rm -f "$CONTAINER" 2>/dev/null || true
    podman run -d --replace --name "$CONTAINER" -p "$PORT" "$IMAGE"

    if [[ -n "$OLD_IMAGE_ID" ]]; then
        podman rmi "$OLD_IMAGE_ID" || true
    fi
else
    echo "Image is up to date. No action taken."
fi
