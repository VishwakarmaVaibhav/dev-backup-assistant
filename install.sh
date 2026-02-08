#!/bin/bash

echo ""
echo "========================================"
echo "   BACKUP PRO - INSTALLER (MacOS/Linux)"
echo "========================================"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed!"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js found"

# Check Zip
if ! command -v zip &> /dev/null; then
    echo "❌ 'zip' command not found!"
    echo "Please install zip."
    exit 1
fi
echo "✅ Zip utility found"

# Install Dependencies
echo ""
echo "Installing dependencies..."
npm install --silent

echo "✅ Dependencies installed"
echo ""

# Run Setup
echo "Installation of dependencies complete."
echo "To configure, run 'node setup.js' or use the GUI installer."
# node setup.js  <-- Removed to avoid double setup when using Install.command

# Offer to install schedule - SKIPPED IN FAVOR OF WEB UI
# echo ""
# read -p "Do you want to install the backup schedule now? (y/n) " -n 1 -r
# echo ""
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#     ./scripts/install-schedule.sh
# fi

echo ""
echo "========================================"
echo "   INSTALLATION COMPLETE!"
echo "========================================"
echo ""
