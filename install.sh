#!/bin/bash

sudo apt-get update
sudo apt-get install curl
sudo apt-get install mysql-client

GITHUB_REPO_URL="https://github.com/yourusername/your-repo-name"
INSTALL_DIR="/opt/mysql_backup"
SERVICE_FILE="mysql_backup.service"
TIMER_FILE="mysql_backup.timer"

echo "Creating installation directory at $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"

echo "Downloading backup script and environment file from GitHub..."
sudo curl -L "$GITHUB_REPO_URL/raw/main/backup.sh" -o "$INSTALL_DIR/backup.sh"
sudo curl -L "$GITHUB_REPO_URL/raw/main/.env" -o "$INSTALL_DIR/.env"

sudo chmod +x "$INSTALL_DIR/backup.sh"

echo "Downloading and setting up systemd service and timer files..."
sudo curl -L "$GITHUB_REPO_URL/raw/main/$SERVICE_FILE" -o "/etc/systemd/system/$SERVICE_FILE"
sudo curl -L "$GITHUB_REPO_URL/raw/main/$TIMER_FILE" -o "/etc/systemd/system/$TIMER_FILE"

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

#echo "Enabling and starting the systemd service and timer..."
#sudo systemctl enable "$SERVICE_FILE" "$TIMER_FILE"
#sudo systemctl start "$SERVICE_FILE" "$TIMER_FILE"

echo "Installation complete! Backup script is set up."
