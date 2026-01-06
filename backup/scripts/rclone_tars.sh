#!/bin/bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SOURCE="${1:-}"
DEST="${2:-}"

if [[ -z "$SOURCE" || -z "$DEST" ]]; then
  log_error "Usage: $0 <source_dir> <dest_dir>"
  exit 1
fi

LATEST_FILE=$(ls -1t "$SOURCE"/*.tar.gz 2>/dev/null | head -n1 || true)

if [[ -z "$LATEST_FILE" || ! -f "$LATEST_FILE" ]]; then
  log_error "No backup file found in $SOURCE"
  exit 1
fi

log_info "Uploading $LATEST_FILE to $DEST ..."

trap - ERR
set +e

rclone copy "$LATEST_FILE" "$DEST" \
  --config /home/s/backup/config/rclone.conf \
  --log-level=INFO \
  --log-file="$LOGFILE" \
  --stats=5s \
  --transfers=8 \
  --checkers=16 \
  --retries=2

RC=$?

set -e
trap 'log_error "Backup failed on line $LINENO"' ERR

if [[ $RC -ge 2 ]]; then
  log_error "rclone failed with fatal exit code $RC"
  exit $RC
elif [[ $RC -eq 1 ]]; then
  log_info "rclone finished with warnings (exit code 1)"
else
  log_info "Upload completed successfully"
fi
