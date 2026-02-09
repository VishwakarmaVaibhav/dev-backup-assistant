#!/bin/bash
# MacOS Uninstaller
echo ""
echo "========================================"
echo "   BACKUP PRO - UNINSTALLER"
echo "========================================"
echo ""

# Uninstall schedule
./scripts/uninstall-schedule.sh

# Remove Node modules
echo "Removing dependencies..."
rm -rf node_modules

echo "✅ Uninstallation complete."
echo "   (Configuration file 'config.json' was kept)"
