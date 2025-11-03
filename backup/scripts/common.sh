#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$ROOT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
  source "$ENV_FILE"
else
  echo "Missing .env file at $ENV_FILE" >&2
  exit 1
fi

mkdir -p "$(dirname "$LOGFILE")"

# Logging helpers
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $*"
}

log_info() {
  log "$*" | tee -a "$LOGFILE"
}

log_error() {
  log "ERROR: $*" | tee -a "$LOGFILE" >&2
}

log_section() {
  echo -e "\n===== $* =====" | tee -a "$LOGFILE"
}

# Error handling
trap 'log_error "Backup failed on line $LINENO"; exit 1' ERR
