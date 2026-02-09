#!/bin/bash
# FIRST RUN FIX - Run this ONCE after downloading to enable double-click install
# This removes macOS security restrictions added during download

echo ""
echo "========================================="
echo "     BACKUP PRO - FIRST RUN FIX"
echo "========================================="
echo ""

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Removing security restrictions..."

# Remove quarantine attribute from all files
xattr -cr "$DIR"

# Make all scripts executable
chmod +x "$DIR/install.sh"
chmod +x "$DIR/Install.command"
chmod +x "$DIR/uninstall.sh"
chmod +x "$DIR"/scripts/*.sh

# Ad-hoc sign the Install.app if it exists
if [ -d "$DIR/Install.app" ]; then
    echo "Signing Install.app..."
    codesign --force --deep --sign - "$DIR/Install.app" 2>/dev/null || true
fi

echo ""
echo "✅ DONE! You can now double-click Install.app or Install.command"
echo ""
echo "Opening the installer now..."
echo ""

# Try to launch Install.app, fallback to Install.command
if [ -d "$DIR/Install.app" ]; then
    open "$DIR/Install.app"
else
    open "$DIR/Install.command"
fi
