#!/bin/bash

# Script to build the iOS app with CastarSDK integration

# Ensure the framework is in the right place
mkdir -p ios/Frameworks
if [ ! -d "ios/Frameworks/CastarSDK.framework" ]; then
  echo "Error: CastarSDK.framework not found in ios/Frameworks directory"
  echo "Please make sure to copy the CastarSDK.framework to the ios/Frameworks directory"
  exit 1
fi

# Create symbolic links for the framework if needed
mkdir -p ios/Flutter/Release
ln -sf "../../Frameworks/CastarSDK.framework" "ios/Flutter/Release/CastarSDK.framework"

# Run pod install
cd ios
pod install
cd ..

# Build the app
flutter build ios --release --no-codesign 