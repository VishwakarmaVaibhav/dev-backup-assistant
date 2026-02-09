#!/bin/bash

# Build Windows Release
APP_NAME="Backup-Pro-Win-v1.1.0"
DIR="backup-pro-win"

echo "Building Windows Release: $APP_NAME.zip"

# Clean up previous build
rm -rf "$DIR"
rm -f "$APP_NAME.zip"

# Create directory structure
mkdir -p "$DIR"

# Copy root files
cp install.bat "$DIR/"
cp uninstall.bat "$DIR/"
cp backup.js "$DIR/"
cp setup.js "$DIR/"
cp setup-server.js "$DIR/"
cp package.json "$DIR/"
cp README.md "$DIR/"
cp LICENSE "$DIR/" 2>/dev/null || true

# Copy Website
cp -r website "$DIR/"

# Copy Scripts
cp -r scripts "$DIR/"

# Create clean config.json for Windows
cat > "$DIR/config.json" <<EOL
{
  "projectPath": "",
  "backupFolder": "",
  "projectName": "MyProject",
  "maxBackups": 10,
  "winrarPath": "",
  "schedule": {
    "monday": {
      "enabled": false,
      "time": "18:00"
    },
    "tuesday": {
      "enabled": false,
      "time": "18:00"
    },
    "wednesday": {
      "enabled": false,
      "time": "18:00"
    },
    "thursday": {
      "enabled": false,
      "time": "18:00"
    },
    "friday": {
      "enabled": false,
      "time": "18:00"
    },
    "saturday": {
      "enabled": false,
      "time": "18:00"
    },
    "sunday": {
      "enabled": false,
      "time": "18:00"
    }
  },
  "excludeFolders": [
    "node_modules",
    ".git",
    "dist",
    "build",
    ".next",
    "__pycache__"
  ]
}
EOL

# Create the Zip
zip -r "$APP_NAME.zip" "$DIR"

# Clean up
rm -rf "$DIR"

echo "✅ Build Complete: $APP_NAME.zip"
