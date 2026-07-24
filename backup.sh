#!/bin/bash
# ============================================================
# backup.sh — Automated Website Backup with Logging & Cleanup
# ------------------------------------------------------------
# This script backs up the World Recipe Collection website
# hosted on Apache. It creates a compressed, timestamped
# archive of the site files, logs the result, and automatically
# removes backups older than 7 days to keep disk usage low.
#
# Usage:
#   chmod +x backup.sh
#   ./backup.sh
#
# To schedule it to run automatically every day at 2am:
#   crontab -e
#   0 2 * * * /home/ubuntu/backup.sh
# ============================================================

BACKUP_DIR="/home/ubuntu/backups"
SITE_DIR="/var/www/html"
LOG_FILE="/home/ubuntu/backups/backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/site_backup_$DATE.tar.gz"
KEEP_DAYS=7

# Create the backup directory if it doesn't already exist
mkdir -p "$BACKUP_DIR"

# Compress the entire website directory into a timestamped archive
tar -czf "$BACKUP_FILE" "$SITE_DIR"

# Check if the backup succeeded and log the result
if [ $? -eq 0 ]; then
    echo "[$DATE] Backup successful: $BACKUP_FILE" >> "$LOG_FILE"
    echo "Backup completed: $BACKUP_FILE"
else
    echo "[$DATE] Backup FAILED" >> "$LOG_FILE"
    echo "Backup failed — check the log at $LOG_FILE"
fi

# Remove backups older than 7 days to save disk space
find "$BACKUP_DIR" -name "site_backup_*.tar.gz" -mtime +$KEEP_DAYS -delete
echo "Old backups cleaned up (kept last $KEEP_DAYS days)"

# Show a summary of current backups
echo ""
echo "Current backups in $BACKUP_DIR:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "No backups found."
