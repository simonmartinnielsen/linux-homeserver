#!/bin/bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SOURCE="$1"
DEST="$2"

if [[ -z "$SOURCE" || -z "$DEST" ]]; then
  log_error "Usage: $0 <source_dir> <dest_dir>"
  exit 1
fi

LATEST_FILE=$(ls -1t "$SOURCE"/*.tar.gz 2>/dev/null | head -n1 || true)

if [[ -f "$LATEST_FILE" ]]; then
  log_info "Uploading $LATEST_FILE to $REMOTE_NAME:$DEST ..."
  rclone copy "$LATEST_FILE" "$REMOTE_NAME:$DEST" \
    --log-level=INFO \
    --log-file="$LOGFILE" \
    --stats=5s \
    --transfers=8 --checkers=16 --retries=2
else
  log_error "No backup file found in $SOURCE"
fi
