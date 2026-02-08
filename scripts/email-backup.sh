#!/bin/bash

# Configuration
CONFIG_FILE="../config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config not found!"
    exit 1
fi

# Find the latest backup zip
BACKUP_FOLDER=$(grep -o '"backupFolder": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
PROJECT_NAME=$(grep -o '"projectName": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)

if [ -z "$BACKUP_FOLDER" ] || [ -z "$PROJECT_NAME" ]; then
    echo "Could not parse config.json"
    exit 1
fi

# Get the most recent zip file starting with ProjectName
LATEST_ZIP=$(ls -t "$BACKUP_FOLDER"/"$PROJECT_NAME"*.zip 2>/dev/null | head -n 1)

if [ -z "$LATEST_ZIP" ]; then
    echo "No backup file found to email."
    exit 1
fi

echo "Preparing to email: $LATEST_ZIP"

# AppleScript to open Mail and attach file
osascript <<EOF
set theAttachment to POSIX file "$LATEST_ZIP"
set theSubject to "Project Backup: $PROJECT_NAME"
set theBody to "Attached is the latest backup for project: $PROJECT_NAME"

tell application "Mail"
    set newMessage to make new outgoing message with properties {subject:theSubject, content:theBody, visible:true}
    tell newMessage
        make new attachment with properties {file name:theAttachment} at after the last paragraph
    end tell
    activate
end tell
EOF

echo "Mail opened with attachment."
