#!/bin/bash

set -e

echo "======================================"
echo "     Production Deployment Started"
echo "======================================"

PROJECT_DIR="/home/ec2-user/my-web-app"
APP_DIR="$PROJECT_DIR/app"
WEB_DIR="/var/www/html"
BACKUP_DIR="/backup"

echo "Creating backup directory..."
sudo mkdir -p "$BACKUP_DIR"

echo "Backing up current website..."
if [ -d "$WEB_DIR" ]; then
    sudo cp -r "$WEB_DIR" "$BACKUP_DIR/html-$(date +%Y%m%d-%H%M%S)"
fi

echo "Deploying latest files..."
sudo rm -rf "$WEB_DIR"/*
sudo cp -r "$APP_DIR"/* "$WEB_DIR"/

echo "Restarting Apache..."
sudo systemctl restart httpd

echo "Running Health Check..."

STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://localhost)

if [ "$STATUS" = "200" ]; then
    echo "Deployment Successful"
else
    echo "Deployment Failed"
    exit 1
fi

echo "======================================"
echo "Deployment Completed Successfully"
echo "======================================"
