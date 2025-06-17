# CastarSDK Integration for iOS

## Installation Steps

### Step 1: Download the SDK
Download the CastarSDK from the developer portal.

### Step 2: Add the Framework to the Project
1. Unzip the downloaded CastarSDK file
2. Copy the `CastarSDK.framework` file to the `my_time/ios/Frameworks/` directory

### Step 3: Add the Framework to Xcode Project
1. Open the iOS project in Xcode by double-clicking on `my_time/ios/Runner.xcworkspace`
2. In Xcode, select the Runner project in the Project Navigator
3. Select the "Runner" target
4. Go to "General" tab
5. Scroll down to "Frameworks, Libraries, and Embedded Content" section
6. Click the "+" button
7. Click "Add Other..." and then "Add Files..."
8. Navigate to the `my_time/ios/Frameworks/` directory and select the `CastarSDK.framework` file
9. Make sure the "Embed" option is set to "Embed & Sign"
10. Click "Add"

### Step 4: Update Build Settings
1. Still in the Xcode project, select the Runner project in the Project Navigator
2. Select the "Runner" target
3. Go to "Build Settings" tab
4. Search for "Framework Search Paths"
5. Add `$(PROJECT_DIR)/Frameworks` to the list

### Step 5: Update Info.plist (if needed)
If CastarSDK requires specific permissions, add them to the Info.plist file.

## Verification
After completing these steps, build the project to verify that the framework is correctly integrated. If there are any linking errors, ensure that the framework is correctly added and embedded.

## GitHub Actions Integration
The GitHub Actions workflow for iOS builds is already set up in the repository. Make sure to add the CastarSDK.framework to the repository or download it during the build process if needed. 