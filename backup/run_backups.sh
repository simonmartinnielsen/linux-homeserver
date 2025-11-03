#!/bin/bash
set -Eeuo pipefail
trap 'log_error "Backup failed on line $LINENO (${BASH_SOURCE[0]})"' ERR

# Helpers and setup
source "$(dirname "$0")/scripts/common.sh"

log_section "Backup started: $(date)"

# Argument parsing
RUN_DOCKER=false
RUN_FS=false
RUN_DIRS=false
CUSTOM_DIRS=()

usage() {
  cat <<EOF
Usage: $0 [options]

Options:
  --fs              Run filesystem backup (local tar + upload)
  --docker          Run Docker backup (local tar + upload)
  --dirs "SRC DEST" Custom directory sync pairs
  --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fs) RUN_FS=true ;;
    --docker) RUN_DOCKER=true ;;
    --dirs)
      RUN_DIRS=true
      shift
      while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
        CUSTOM_DIRS+=("$1")
        shift
      done
      continue
      ;;
    --help) usage; exit 0 ;;
    *)
      log_error "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

# Tasks
if $RUN_FS; then
  log_section "Backing up filesystem..."
  if ! sudo bash "$SCRIPTS_DIR/fs_backup.sh"; then
    log_error "Filesystem backup failed"
  fi
  log_section "Uploading file system backup to $REMOTE_NAME..."
  bash "$SCRIPTS_DIR/rclone_tars.sh" "$FS_TAR_DIR" "$FS_REMOTE_DIR"
fi


if $RUN_DOCKER; then
  log_info "Backing up Docker..."
  bash "$SCRIPTS_DIR/docker_backup.sh"
  bash "$SCRIPTS_DIR/rclone_tars.sh" "$DOCKER_TAR_DIR" "$DOCKER_REMOTE_DIR"
fi

if $RUN_DIRS; then
  if [[ ${#CUSTOM_DIRS[@]} -eq 0 ]]; then
    log_error "--dirs specified but no pairs given"
  else
    log_info "Syncing custom directories..."
    bash "$SCRIPTS_DIR/rclone_backups.sh" "${CUSTOM_DIRS[@]}"
  fi
fi

if ! $RUN_FS && ! $RUN_DOCKER && ! $RUN_DIRS; then
  usage
fi

log_section "Backup finished: $(date)"
