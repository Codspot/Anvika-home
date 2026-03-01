#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${ANVIKA_IMAGE:-${CLAWDBOT_IMAGE:-anvika:local}}"
CONFIG_DIR="${ANVIKA_CONFIG_DIR:-${CLAWDBOT_CONFIG_DIR:-$HOME/.anvika}}"
WORKSPACE_DIR="${ANVIKA_WORKSPACE_DIR:-${CLAWDBOT_WORKSPACE_DIR:-$HOME/.anvika/workspace}}"
PROFILE_FILE="${ANVIKA_PROFILE_FILE:-${CLAWDBOT_PROFILE_FILE:-$HOME/.profile}}"

PROFILE_MOUNT=()
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE_MOUNT=(-v "$PROFILE_FILE":/home/node/.profile:ro)
fi

echo "==> Build image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo "==> Run gateway live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e ANVIKA_LIVE_TEST=1 \
  -e ANVIKA_LIVE_GATEWAY_MODELS="${ANVIKA_LIVE_GATEWAY_MODELS:-${CLAWDBOT_LIVE_GATEWAY_MODELS:-modern}}" \
  -e ANVIKA_LIVE_GATEWAY_PROVIDERS="${ANVIKA_LIVE_GATEWAY_PROVIDERS:-${CLAWDBOT_LIVE_GATEWAY_PROVIDERS:-}}" \
  -e ANVIKA_LIVE_GATEWAY_MAX_MODELS="${ANVIKA_LIVE_GATEWAY_MAX_MODELS:-${CLAWDBOT_LIVE_GATEWAY_MAX_MODELS:-24}}" \
  -e ANVIKA_LIVE_GATEWAY_MODEL_TIMEOUT_MS="${ANVIKA_LIVE_GATEWAY_MODEL_TIMEOUT_MS:-${CLAWDBOT_LIVE_GATEWAY_MODEL_TIMEOUT_MS:-}}" \
  -v "$CONFIG_DIR":/home/node/.anvika \
  -v "$WORKSPACE_DIR":/home/node/.anvika/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
