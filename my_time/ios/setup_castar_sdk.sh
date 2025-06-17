#!/bin/bash

# Script to set up CastarSDK for iOS

# Create Frameworks directory if it doesn't exist
mkdir -p Frameworks

# Check if CastarSDK.framework already exists
if [ -d "Frameworks/CastarSDK.framework" ]; then
    echo "CastarSDK.framework already exists."
else
    echo "CastarSDK.framework not found. Please place the CastarSDK.framework in the Frameworks directory."
    echo "You can download it from the CastarSDK developer portal."
    echo ""
    echo "After downloading, unzip the file and place the CastarSDK.framework in the ios/Frameworks directory."
    exit 1
fi

# Run pod install
echo "Running pod install..."
pod install

echo "CastarSDK setup completed successfully!"
echo "You can now build the iOS app using: flutter build ios --release --no-codesign" 