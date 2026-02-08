#!/bin/bash
# Helper script to start the server from Install.app

# Resolve script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$DIR/.."

# Detect Node path
NODE_BIN=$(which node)
if [ -z "$NODE_BIN" ]; then
    if [ -f "/usr/local/bin/node" ]; then NODE_BIN="/usr/local/bin/node"; fi
    if [ -f "/opt/homebrew/bin/node" ]; then NODE_BIN="/opt/homebrew/bin/node"; fi
fi

if [ -z "$NODE_BIN" ]; then
    osascript -e 'display notification "Node.js not found! Please install Node.js." with title "Error"'
    exit 1
fi

# Ensure install.sh runs (silent)
cd "$PROJECT_ROOT"
"$NODE_BIN" -v > /dev/null
if [ ! -d "node_modules" ]; then
    # Run npm install if needed
    npm install --silent > /dev/null 2>&1
fi

# Launch Server (detached)
# We use nohup to keep it running even if the parent (App) closes logic
# However, the App stays open as long as this runs unless we background it.
# We want the App to just "open" the UI and maybe exit?
# But the server needs to keep running.
# Let's run it in background and let the App exit.

# Cleanup existing instances of setup-server
pkill -f "setup-server.js" > /dev/null 2>&1

cd "$PROJECT_ROOT"
osascript -e 'display notification "Launching Setup UI..." with title "Backup Pro"'
"$NODE_BIN" setup-server.js > /dev/null 2>&1 &
