#!/bin/bash
# ============================================================
# backup.sh
# ------------------------------------------------------------
# Purpose: Creates a timestamped compressed backup of the
# World Recipe Collection website files hosted on this EC2
# server. Useful in case the server is accidentally deleted,
# corrupted, or needs to be restored quickly.
#
# What it does:
#   1. Creates a backups directory if it doesn't already exist.
#   2. Compresses the entire website directory (/var/www/html)
#      into a single .tar.gz file.
#   3. Names the backup file with the current date and time,
#      so multiple backups can be kept without overwriting
#      each other.
#   4. Prints a confirmation message with the backup location.
#
# Usage:
#   chmod +x backup.sh
#   ./backup.sh
#
# Optional: Add this to a cron job to run automatically,
# e.g. every day at 2am:
#   crontab -e
#   0 2 * * * /home/ubuntu/backup.sh
# ============================================================

BACKUP_DIR="/home/ubuntu/backups"
SITE_DIR="/var/www/html"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/site_backup_$DATE.tar.gz"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Compress the website directory into a timestamped archive
tar -czf "$BACKUP_FILE" "$SITE_DIR"

# Confirm success
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "Backup failed. Please check permissions and paths."
fi
