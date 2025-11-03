#!/bin/bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"


DATE_STR=$(date +%F)
FILE="fs-$DATE_STR.tar.gz"
BACKUP_DIRS="/etc /home /root /var/lib /boot /opt /usr/local"

exclude_list=(
  --exclude=/var/lib/docker
  --exclude=/var/lib/containerd
  --exclude=/var/lib/snapd
  --exclude=/var/cache/*
  --exclude=/tmp/*
  --exclude=/var/tmp/*
  --exclude=/var/backups/*
  --exclude=/mnt/*
  --exclude=/media/*
  --exclude=/run/*
  --exclude=/swapfile
)

mkdir -p "$FS_TAR_DIR"
log_info "Creating filesystem archive $FILE..."
tar -czf "$FS_TAR_DIR/$FILE" "${exclude_list[@]}" $BACKUP_DIRS 2>>"$LOGFILE"
