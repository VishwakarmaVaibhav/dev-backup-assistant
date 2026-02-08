#!/bin/bash

# Configuration
CONFIG_FILE="../config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config not found!"
    exit 1
fi

PROJECT_NAME=$(grep -o '"projectName": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)

# Show Dialog
RESULT=$(osascript -e "display dialog \"Time effectively for backup of Project: $PROJECT_NAME. Do you want to backup now?\" buttons {\"Skip\", \"Backup Now\"} default button \"Backup Now\" with icon note")

if [[ "$RESULT" == *"button returned:Backup Now"* ]]; then
    # Run Backup
    PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    cd "$PROJECT_DIR"
    
    
    # Use full path to node if provided as argument
    if [ ! -z "$1" ]; then
        NODE_BIN="$1"
    else
        # Fallback detection
        NODE_BIN=$(which node)
        if [ -z "$NODE_BIN" ]; then
            if [ -f "/usr/local/bin/node" ]; then NODE_BIN="/usr/local/bin/node"; fi
            if [ -f "/opt/homebrew/bin/node" ]; then NODE_BIN="/opt/homebrew/bin/node"; fi
            # Try to start-server.sh logic if available? No, simpler is better.
        fi
    fi
    
    if [ -z "$NODE_BIN" ]; then
        osascript -e "display notification \"Error: Node.js not found in path.\" with title \"Backup Pro Error\""
        exit 1
    fi

    "$NODE_BIN" backup.js
    
    # Check exit code
    if [ $? -eq 0 ]; then
        # Success Notification
        osascript -e "display notification \"Backup saved at: $BACKUP_FOLDER\" with title \"Backup Success\""
        
        # Post-backup options
        ACTION=$(osascript -e "display dialog \"Backup Complete! Saved to:
$BACKUP_FOLDER

What would you like to do?\" buttons {\"Close\", \"Show in Finder\", \"Email Backup\"} default button \"Show in Finder\" with icon stop")
        
        if [[ "$ACTION" == *"button returned:Show in Finder"* ]]; then
             BACKUP_FOLDER=$(grep -o '"backupFolder": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
             open "$BACKUP_FOLDER"
        elif [[ "$ACTION" == *"button returned:Email Backup"* ]]; then
             cd scripts
             ./email-backup.sh
        fi
    else
        # Failure Notification
        osascript -e "display notification \"Backup failed. check logs.\" with title \"Backup Pro Error\""
    fi
fi
