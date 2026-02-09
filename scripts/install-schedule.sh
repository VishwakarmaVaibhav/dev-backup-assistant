#!/bin/bash

# Install Scheduled Tasks for Daily Backup (MacOS/Linux via Crontab)

echo ""
echo "========================================"
echo "   INSTALLING BACKUP SCHEDULER"
echo "========================================"
echo ""

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config.json"
BACKUP_POPUP="$SCRIPT_DIR/backup-popup.sh"

# Make scripts executable
chmod +x "$BACKUP_POPUP"
chmod +x "$SCRIPT_DIR/email-backup.sh"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config not found! Please run setup first."
    exit 1
fi

# We will use crontab.
# First, remove existing backup tasks from crontab to avoid duplicates.
# We identify our tasks by a comment # BackupPro-[Day]

echo "   Cleaning old tasks..."
# Dump current cron, remove lines with BackupPro, save to temp
crontab -l 2>/dev/null | grep -v "BackupPro" > /tmp/cron_bkp

# Read Config (using Node/Python or simple grep)
# Since we have node, let's use a tiny node script to parse config and output cron lines
# Detect Node path for Cron
if [ ! -z "$1" ]; then
    NODE_BIN="$1"
else
    NODE_BIN=$(which node)
    if [ -z "$NODE_BIN" ]; then
        if [ -f "/usr/local/bin/node" ]; then NODE_BIN="/usr/local/bin/node"; fi
        if [ -f "/opt/homebrew/bin/node" ]; then NODE_BIN="/opt/homebrew/bin/node"; fi
        if [ -f "$HOME/.nvm/versions/node/*/bin/node" ]; then 
            # Try to find latest nvm node
            NODE_BIN=$(ls -1d "$HOME/.nvm/versions/node/"*"/bin/node" | head -n 1) 
        fi
    fi
    [ -z "$NODE_BIN" ] && NODE_BIN="node" # Fallback
fi

# We have node, let's use a tiny node script to parse config and output cron lines
NODE_SCRIPT="
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('$CONFIG_FILE', 'utf8'));
const daysMap = {
    'monday': 1, 'tuesday': 2, 'wednesday': 3, 'thursday': 4, 
    'friday': 5, 'saturday': 6, 'sunday': 0
};

Object.keys(config.schedule).forEach(day => {
    const s = config.schedule[day];
    if (s.enabled) {
        const parts = s.time.split(':');
        const h = parts[0];
        const m = parts[1];
        const dow = daysMap[day];
        
        // Cron format: m h * * dow command
        // We pass NODE_BIN to backup-popup.sh so it knows which node to use
        console.log(\`\${m} \${h} * * \${dow} cd \\\"$SCRIPT_DIR\\\" && ./backup-popup.sh \\\"$NODE_BIN\\\" # BackupPro-\${day}\`);
    }
});
"

# Generate new cron lines
"$NODE_BIN" -e "$NODE_SCRIPT" >> /tmp/cron_bkp

# Install new cron
crontab /tmp/cron_bkp
rm /tmp/cron_bkp

echo "   ✅ Schedule installed locally via crontab."
echo "   (Note: Ensure your Mac is awake at these times!)"
echo ""
