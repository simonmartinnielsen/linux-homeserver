# Backup Scripts

A set of Bash scripts for automated local and remote backups of filesystem data and Docker containers, with logging and optional directory sync via `rclone`.

---

## Features

- **Filesystem backup**: Creates compressed `.tar.gz` archives of key system directories (`/etc`, `/home`, `/var/lib`, etc.), excluding caches and temporary files.
- **Docker backup**: Stops containers, archives the Docker folder, and restarts containers automatically.
- **Remote sync**: Upload backups to any `rclone`-compatible provider.
- **Custom directory sync**: Specify additional folders to sync to remote storage.
- **Centralized logging**: Log all important events to a configurable logfile.
- **Error handling**: Scripts exit on errors and log line numbers for easier debugging.

---

## Prerequisites

- Bash 4+  
- `tar`  
- `rclone` configured with your remote (`REMOTE_NAME`)  
- Docker + Docker Compose (for container backups)  
- Sudo privileges for filesystem backups

---

## Setup

1. Clone the repository:

   ```bash
   git clone <repo_url>
   cd backup

2. Configure .env file:
```bash
LOGFILE="/home/user/backup/logs/backups.log"

SCRIPTS_DIR="/home/user/backup/scripts"
DOCKER_DIR="/home/user/docker"

FS_TAR_DIR="/mnt/HDD/backup/fs"
DOCKER_TAR_DIR="/mnt/HDD/backup/docker"

REMOTE_NAME="googledrive"

FS_REMOTE_DIR="backup/fs"
DOCKER_REMOTE_DIR="backup/docker"
```

3. Ensure the logs/ and backup directories exist:
```bash
mkdir -p logs "$FS_TAR_DIR" "$DOCKER_TAR_DIR"
```

## Usage

Run backups using run_backups.sh with flags:
```bash
./run_backups.sh [options]
```

### Options
- --fs – Run filesystem backup
- --docker – Run Docker backup
- --dirs "SRC DEST" – Sync custom directories (can specify multiple pairs)
- --help – Show usage instructions

```bash
# Backup filesystem only
./run_backups.sh --fs

# Backup Docker and upload to remote
./run_backups.sh --docker

# Backup filesystem and Docker
./run_backups.sh --fs --docker

# Sync custom directories
./run_backups.sh --dirs "/mnt/HDD/Docs backups/docs" "/mnt/HDD/Media backups/media"
```

## Logging
Important events are logged to the file specified in .env (LOGFILE).
Only relevant backup and error events are logged to keep files readable.

## Notes
Scripts are safe to run multiple times; latest backups are always uploaded.
Use crontab or systemd timers for scheduled automated backups.
