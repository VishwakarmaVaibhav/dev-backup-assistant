#!/bin/bash

# Get the directory where the script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make sure install.sh is executable
echo "Starting Backup Pro Installer..."
osascript -e 'display notification "Installing Backup Pro..." with title "Backup Pro Installer"'
cd "$DIR"
chmod +x install.sh
chmod +x scripts/*.sh

# Run Install Script
./install.sh
# Launch Web-Based GUI Setup
echo "Launching Setup UI..."
node ./setup-server.js

# Keep window open if there was an error
if [ $? -ne 0 ]; then
    echo ""
    echo "Installation encountered an error."
    echo "Press any key to close..."
    read -n 1
fi
