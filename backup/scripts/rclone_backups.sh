#!/bin/bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

BACKUPS=("$@")
if [[ ${#BACKUPS[@]} -eq 0 ]]; then
  log_error "No directory pairs provided."
  exit 1
fi

for PAIR in "${BACKUPS[@]}"; do
  SRC=$(echo "$PAIR" | awk '{print $1}')
  DEST=$(echo "$PAIR" | awk '{print $2}')
  log_info "Syncing $SRC → $REMOTE_NAME:$DEST"
  rclone sync "$SRC" "$REMOTE_NAME:$DEST" \
    --log-level=INFO \
    --log-file="$LOGFILE" \
    --stats=5s \
    --transfers=8 --checkers=16 --retries=2
done
