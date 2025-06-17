#!/bin/bash

# This script helps link the CastarSDK.framework to the Xcode project

# Ensure we're in the ios directory
cd "$(dirname "$0")"

# Check if the framework exists
if [ ! -d "Frameworks/CastarSDK.framework" ]; then
  echo "Error: CastarSDK.framework not found in the Frameworks directory"
  exit 1
fi

# Create a symbolic link to the framework in the Flutter build directory
mkdir -p Flutter/Release
ln -sf "../../Frameworks/CastarSDK.framework" "Flutter/Release/CastarSDK.framework"

echo "Framework linked successfully. Now open Runner.xcworkspace in Xcode and:"
echo "1. Select the Runner project in the Project Navigator"
echo "2. Select the Runner target"
echo "3. Go to the General tab"
echo "4. Scroll down to Frameworks, Libraries, and Embedded Content"
echo "5. Click the + button"
echo "6. Click Add Other... then Add Files..."
echo "7. Navigate to and select the CastarSDK.framework file"
echo "8. Make sure Embed & Sign is selected in the Embed column"
echo ""
echo "Then build and run the app on your iOS device or simulator." 