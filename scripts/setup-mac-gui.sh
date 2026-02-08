#!/bin/bash

# ========================================
#  BACKUP PRO - MAC SETUP WIZARD
# ========================================

echo "Starting Setup Wizard..."

# Function to run osascript easily
function dialog() {
    osascript -e "$1" 2>/dev/null
}

# 1. Welcome Screen
BUTTON=$(dialog 'display dialog "Welcome to Backup Pro Setup!\n\nThis wizard will configure your automatic backups." buttons {"Cancel", "Get Started"} default button "Get Started" with icon note')
if [[ "$BUTTON" != "button returned:Get Started" ]]; then
    echo "Setup Cancelled."
    exit 0
fi

# 2. Select Project Folder
dialog 'display dialog "Step 1: Select your PROJECT folder (Source)." buttons {"OK"} default button "OK"'
PROJECT_PATH=$(osascript -e 'Tell application "System Events" to activate' -e 'POSIX path of (choose folder with prompt "Select your PROJECT folder:")')
if [ -z "$PROJECT_PATH" ]; then echo "Cancelled."; exit 0; fi

# 3. Select Backup Destination
dialog 'display dialog "Step 2: Select your BACKUP DESTINATION folder." buttons {"OK"} default button "OK"'
BACKUP_PATH=$(osascript -e 'Tell application "System Events" to activate' -e 'POSIX path of (choose folder with prompt "Select your BACKUP DESTINATION folder:")')
if [ -z "$BACKUP_PATH" ]; then echo "Cancelled."; exit 0; fi

# 4. Project Name
PROJECT_NAME_RAW=$(dialog 'display dialog "Step 3: Enter a name for this project:" default answer "MyProject" buttons {"OK"} default button "OK"')
PROJECT_NAME=$(echo "$PROJECT_NAME_RAW" | sed 's/text returned://' | sed 's/, button returned:OK//')
if [ -z "$PROJECT_NAME" ]; then PROJECT_NAME="MyProject"; fi

# 5. Backup Schedule (Days)
DAYS_RAW=$(osascript -e 'choose from list {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"} with title "Schedule" with prompt "Select days to run backup (Cmd+Click for multiple):" default items {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"} with multiple selections allowed')
if [ "$DAYS_RAW" == "false" ]; then DAYS_RAW="Monday, Tuesday, Wednesday, Thursday, Friday"; fi

# 6. Backup Time
TIME_RAW=$(dialog 'display dialog "Step 4: Enter daily backup time (24h format HH:MM):" default answer "18:00" buttons {"OK"} default button "OK"')
TIME=$(echo "$TIME_RAW" | sed 's/text returned://' | sed 's/, button returned:OK//')

# 7. Confirm
CONFIRM=$(dialog "display dialog \"Review Settings:\n\nProject: $PROJECT_NAME\nSource: $PROJECT_PATH\nDest: $BACKUP_PATH\nTime: $TIME\n\nSave these settings?\" buttons {\"Cancel\", \"Save\"} default button \"Save\"")
if [[ "$CONFIRM" != "button returned:Save" ]]; then
    echo "Cancelled."
    exit 0
fi

# 8. Generate config.json using Node.js
# We need to construct the JSON carefully
# Convert Days string "Monday, Tuesday" to array and map to config object structure

NODE_SCRIPT="
const fs = require('fs');
const path = require('path');

const config = {
  projectPath: '$PROJECT_PATH',
  backupFolder: '$BACKUP_PATH',
  projectName: '$PROJECT_NAME',
  maxBackups: 10,
  winrarPath: '',
  excludeFolders: ['node_modules', '.git', 'dist', 'build', '.next', '__pycache__'],
  schedule: {
    monday: { enabled: false, time: '$TIME' },
    tuesday: { enabled: false, time: '$TIME' },
    wednesday: { enabled: false, time: '$TIME' },
    thursday: { enabled: false, time: '$TIME' },
    friday: { enabled: false, time: '$TIME' },
    saturday: { enabled: false, time: '$TIME' },
    sunday: { enabled: false, time: '$TIME' }
  }
};

const daysSelected = '$DAYS_RAW'.toLowerCase();

Object.keys(config.schedule).forEach(day => {
    if (daysSelected.includes(day)) {
        config.schedule[day].enabled = true;
    }
});

fs.writeFileSync('../config.json', JSON.stringify(config, null, 2));
console.log('Config saved.');
"

# Run Node script
# Ensure we are in the scripts directory or resolve path correctly
cd "$(dirname "$0")"
node -e "$NODE_SCRIPT"

# 9. Offer to Install Schedule
INSTALL_SCH=$(dialog "display dialog \"Settings Saved!\n\nDo you want to install these scheduled tasks now?\" buttons {\"Skip\", \"Install Schedule\"} default button \"Install Schedule\" with icon note")

if [[ "$INSTALL_SCH" == "button returned:Install Schedule" ]]; then
    ./install-schedule.sh
    dialog 'display dialog "Setup Complete! Your backups are now scheduled." buttons {"Done"} default button "Done" with icon note'
else 
    dialog 'display dialog "Setup Complete! (Schedule not installed)" buttons {"Done"} default button "Done" with icon note'
fi
