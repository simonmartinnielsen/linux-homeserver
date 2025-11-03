#!/bin/bash
set -Eeuo pipefail
source "$(dirname "$0")/common.sh"

DATE=$(date +%F)
ARCHIVE_NAME="docker_backup_$DATE.tar.gz"

log_info "Stopping Docker containers..."
docker compose -f "$DOCKER_DIR/docker-compose.yml" down

mkdir -p "$DOCKER_TAR_DIR"
log_info "Creating archive $ARCHIVE_NAME..."
tar -czf "$DOCKER_TAR_DIR/$ARCHIVE_NAME" -C "/home/s" "docker"

log_info "Starting Docker containers..."
docker compose -f "$DOCKER_DIR/docker-compose.yml" up -d
