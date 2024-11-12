# mysql-s3-backup

## Run commands step by step:
1. `bash <(curl -L -s https://raw.githubusercontent.com/ackn0wl3dgm3nt/mysql-s3-backup/main/install.sh)`
2. Configure S3 access: `s3cmd --configure`
3. Fill `/opt/mysql_backup.env` file with your data
4. Run service: `sudo systemctl enable mysql_backup.service mysql_backup.timer` then `sudo systemctl start mysql_backup.service mysql_backup.timer`

- Script runs every hour by default. You can change frequence in `/opt/mysql_backup.timer` file changing `OnCalendar` parameter
