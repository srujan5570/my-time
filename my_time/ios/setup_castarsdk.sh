#!/bin/bash

# Script to set up CastarSDK for iOS in a Flutter project
# Usage: ./setup_castarsdk.sh [path_to_castarsdk_framework]

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}CastarSDK iOS Setup Script${NC}"
echo "=============================="

# Check if the CastarSDK framework path is provided
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage: ./setup_castarsdk.sh [path_to_castarsdk_framework]${NC}"
  echo "Please provide the path to the CastarSDK.framework file."
  exit 1
fi

FRAMEWORK_PATH="$1"

# Check if the framework exists
if [ ! -d "$FRAMEWORK_PATH" ]; then
  echo -e "${RED}Error: CastarSDK framework not found at $FRAMEWORK_PATH${NC}"
  exit 1
fi

# Create Frameworks directory if it doesn't exist
echo "Creating Frameworks directory..."
mkdir -p Frameworks

# Copy the framework to the Frameworks directory
echo "Copying CastarSDK framework..."
cp -R "$FRAMEWORK_PATH" Frameworks/

# Check if the copy was successful
if [ ! -d "Frameworks/CastarSDK.framework" ]; then
  echo -e "${RED}Error: Failed to copy CastarSDK framework${NC}"
  exit 1
fi

echo -e "${GREEN}CastarSDK framework copied successfully!${NC}"

# Create podspec file
echo "Creating podspec file..."
cat > Frameworks/CastarSDK.podspec << EOL
Pod::Spec.new do |s|
  s.name             = 'CastarSDK'
  s.version          = '1.0.0'
  s.summary          = 'CastarSDK for iOS'
  s.description      = 'CastarSDK SDK for iOS helps you make money with iOS apps.'
  s.homepage         = 'https://castar.com'
  s.license          = { :type => 'Commercial', :text => 'Copyright (c) 2024 Castar. All rights reserved.' }
  s.author           = { 'Castar' => 'support@castar.com' }
  s.source           = { :path => '.' }
  s.platform         = :ios, '12.0'
  s.preserve_paths   = 'CastarSDK.framework'
  s.vendored_frameworks = 'CastarSDK.framework'
  s.frameworks       = 'Foundation', 'UIKit'
  s.requires_arc     = true
  s.swift_version    = '5.0'
end
EOL

echo -e "${GREEN}Podspec file created successfully!${NC}"

# Update Podfile
echo "Updating Podfile..."
if [ -f "Podfile" ]; then
  # Check if CastarSDK is already in Podfile
  if grep -q "pod 'CastarSDK'" Podfile; then
    echo "CastarSDK already in Podfile."
  else
    # Add CastarSDK to Podfile
    sed -i '' 's/target '\''Runner'\'' do/target '\''Runner'\'' do\n  # Add CastarSDK framework\n  pod '\''CastarSDK'\'', :path => '\''Frameworks'\''/g' Podfile
    echo "Added CastarSDK to Podfile."
  fi
  
  # Make sure iOS platform version is at least 12.0
  if grep -q "platform :ios" Podfile; then
    sed -i '' 's/platform :ios, '\''[0-9.]*'\''/platform :ios, '\''12.0'\''/g' Podfile
    echo "Updated iOS platform version to 12.0."
  else
    sed -i '' '1s/^/platform :ios, '\''12.0'\''\n\n/' Podfile
    echo "Added iOS platform version 12.0."
  fi
else
  echo -e "${RED}Error: Podfile not found${NC}"
  exit 1
fi

# Run pod install
echo "Running pod install..."
pod install

echo -e "${GREEN}Setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Open the Xcode workspace: open Runner.xcworkspace"
echo "2. Verify that CastarSDK.framework is added to the 'Frameworks, Libraries, and Embedded Content' section"
echo "3. Make sure the 'Embed' option is set to 'Embed & Sign'"
echo "4. Build and run the project to verify the integration"
echo ""
echo "For more details, see the MANUAL_SETUP.md file." 