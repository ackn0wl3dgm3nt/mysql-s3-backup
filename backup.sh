#!/bin/bash

set +e
export $(grep -v '^#' .env | xargs)

BACKUP_DIR="/var/lib/mysql_backups"
TIMESTAMP=$(date +"%F_%T")

mkdir -p "$BACKUP_DIR"

if [[ -z "$MYSQL_DATABASE" ]]; then
    BACKUP_FILE="$BACKUP_DIR/full_backup_$TIMESTAMP.sql"
    mysqldump -u "$MYSQL_USER" -h "$MYSQL_HOST" -p"$MYSQL_PASSWORD" --all-databases > "$BACKUP_FILE"
else
    BACKUP_FILE="$BACKUP_DIR/${MYSQL_DATABASE}_backup_$TIMESTAMP.sql"
    mysqldump -u "$MYSQL_USER" -h "$MYSQL_HOST" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" > "$BACKUP_FILE"
fi

gzip "$BACKUP_FILE"
BACKUP_FILE_GZ="$BACKUP_FILE.gz"

aws s3 cp "$BACKUP_FILE_GZ" "$S3_BUCKET/"

find "$BACKUP_DIR" -type f -name "*.gz" -mtime +7 -exec rm {} \;

echo "Backup completed and uploaded to S3: $S3_BUCKET/$(basename "$BACKUP_FILE_GZ")"
