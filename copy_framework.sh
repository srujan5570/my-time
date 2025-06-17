#!/bin/bash

# Script to copy CastarSDK.framework to the correct location for Flutter iOS builds

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source and destination paths
SOURCE_FRAMEWORK="$SCRIPT_DIR/ios/Frameworks/CastarSDK.framework"
DEST_DIR="$SCRIPT_DIR/build/ios/Debug-iphoneos/Runner.app/Frameworks"
DEST_FRAMEWORK="$DEST_DIR/CastarSDK.framework"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Copy the framework
echo "Copying CastarSDK.framework to $DEST_DIR"
cp -R "$SOURCE_FRAMEWORK" "$DEST_DIR"

# Make sure the framework has the correct permissions
chmod -R 755 "$DEST_FRAMEWORK"

echo "CastarSDK.framework copied successfully" 