#!/bin/bash

# Build Script for MacOS Release

VERSION=$(grep -o '"version": *"[^"]*"' package.json | cut -d'"' -f4)
ZIP_NAME="Backup-Pro-Mac-v$VERSION.zip"
DIR_NAME="backup-pro-mac"

echo "Building Release: $ZIP_NAME"

# Clean previous build
rm -rf "$DIR_NAME"
rm -f "$ZIP_NAME"

# Create directory structure
mkdir "$DIR_NAME"
mkdir "$DIR_NAME/scripts"

# Copy files
cp install.sh "$DIR_NAME/"
cp Install.command "$DIR_NAME/"
cp uninstall.sh "$DIR_NAME/"
cp package.json "$DIR_NAME/"
cp backup.js "$DIR_NAME/"
cp setup.js "$DIR_NAME/"
cp config.json "$DIR_NAME/" 2>/dev/null # Optional if exists pattern
cp README.md "$DIR_NAME/"
cp LICENSE "$DIR_NAME/"
cp MAC_INSTALL.md "$DIR_NAME/" 2>/dev/null || true
cp FIRST_RUN_FIX.command "$DIR_NAME/" 2>/dev/null || true

# Compile AppleScript to App
echo "Compiling Install.app..."
osacompile -o "$DIR_NAME/Install.app" scripts/mac-launcher.applescript

# Ad-hoc code sign the app (FREE - no Apple Developer account needed!)
# This helps bypass Gatekeeper on many systems
echo "Code signing Install.app (ad-hoc)..."
codesign --force --deep --sign - "$DIR_NAME/Install.app" 2>/dev/null || echo "Note: codesign not available, skipping..."

# Remove quarantine attributes from the entire folder
echo "Removing quarantine flags..."
xattr -cr "$DIR_NAME" 2>/dev/null || true

# Copy scripts
cp scripts/install-schedule.sh "$DIR_NAME/scripts/"
cp scripts/uninstall-schedule.sh "$DIR_NAME/scripts/"
cp scripts/backup-popup.sh "$DIR_NAME/scripts/"
cp scripts/email-backup.sh "$DIR_NAME/scripts/"
cp scripts/start-server.sh "$DIR_NAME/scripts/"
cp setup-server.js "$DIR_NAME/"
cp -r website "$DIR_NAME/"

# Create zip
zip -r "$ZIP_NAME" "$DIR_NAME" -x "*.DS_Store"

# Cleanup
rm -rf "$DIR_NAME"

echo "✅ Build Complete: $ZIP_NAME"
