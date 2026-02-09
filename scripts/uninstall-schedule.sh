#!/bin/bash

echo "Removing all Backup Pro scheduled tasks..."

# Remove lines containing BackupPro from crontab
crontab -l 2>/dev/null | grep -v "BackupPro" | crontab -

echo "✅ Tasks removed."
