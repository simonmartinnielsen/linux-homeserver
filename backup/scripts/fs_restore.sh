#!/bin/bash

usage() {
    echo "Usage: sudo ./fs_restore.sh -f /path/to/backup.tar.gz"
    exit 1
}

BACKUP_FILE=""
while [ "$1" != "" ]; do
    case $1 in
        -f | --file ) shift; BACKUP_FILE=$1 ;;
        -h | --help ) usage ;;
        * ) usage ;;
    esac
    shift
done

if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found."; usage
fi

read -p "This will overwrite system files. Continue? [y/N] " confirm
case $confirm in
    [Yy]* ) ;;
    * ) echo "Aborted."; exit 1;;
esac

TMP_DIR="/tmp/fs-restore"
sudo mkdir -p "$TMP_DIR"
sudo tar -xzf "$BACKUP_FILE" -C "$TMP_DIR"

sudo rsync -acvxAP --info=progress2 --delete-before --numeric-ids \
  --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found","/var/lib/docker"} \
  "$TMP_DIR"/ /

sudo rm -rf "$TMP_DIR"
echo "Restore complete. Reboot recommended."
