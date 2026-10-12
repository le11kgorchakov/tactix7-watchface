#!/usr/bin/env bash
# Usage: ./build.sh [run]   (run = build, launch simulator, load the face)
set -euo pipefail

DEVICE="${DEVICE:-fenix7x}"
KEY="${KEY:-$HOME/.garmin/developer_key.der}"
CIQ_HOME="$HOME/Library/Application Support/Garmin/ConnectIQ"
SDK="${SDK:-$(cat "$CIQ_HOME/current-sdk.cfg")}"
OUT="bin/Tactix7Face.prg"

export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
cd "$(dirname "$0")"
mkdir -p bin

"$SDK/bin/monkeyc" -d "$DEVICE" -f monkey.jungle -o "$OUT" -y "$KEY" -w -r
echo "Built $OUT"

if [[ "${1:-}" == "run" ]]; then
  "$SDK/bin/connectiq" &
  sleep 3
  "$SDK/bin/monkeydo" "$OUT" "$DEVICE"
fi
