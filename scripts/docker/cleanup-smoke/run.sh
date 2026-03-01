#!/usr/bin/env bash
set -euo pipefail

cd /repo

export ANVIKA_STATE_DIR="/tmp/anvika-test"
export ANVIKA_CONFIG_PATH="${ANVIKA_STATE_DIR}/anvika.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${ANVIKA_STATE_DIR}/credentials"
mkdir -p "${ANVIKA_STATE_DIR}/agents/main/sessions"
echo '{}' >"${ANVIKA_CONFIG_PATH}"
echo 'creds' >"${ANVIKA_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${ANVIKA_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm anvika reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${ANVIKA_CONFIG_PATH}"
test ! -d "${ANVIKA_STATE_DIR}/credentials"
test ! -d "${ANVIKA_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${ANVIKA_STATE_DIR}/credentials"
echo '{}' >"${ANVIKA_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm anvika uninstall --state --yes --non-interactive

test ! -d "${ANVIKA_STATE_DIR}"

echo "OK"
