# Manual Setup Guide for CastarSDK on iOS

This guide provides step-by-step instructions for manually adding the CastarSDK framework to your iOS project.

## Prerequisites
- Xcode 15.3+
- iOS 12.0+ deployment target
- CastarSDK.framework file (downloaded from the CastarSDK developer portal)

## Step 1: Add the Framework to the Project

1. Create a `Frameworks` folder in your iOS project folder if it doesn't already exist:
   ```bash
   mkdir -p ios/Frameworks
   ```

2. Copy the CastarSDK.framework file to the Frameworks folder:
   ```bash
   cp /path/to/downloaded/CastarSDK.framework ios/Frameworks/
   ```

## Step 2: Configure Xcode Project

1. Open the Xcode workspace:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. In Xcode Project Navigator, right-click on the "Runner" project and select "Add Files to 'Runner'..."

3. Navigate to the `ios/Frameworks` directory, select the `CastarSDK.framework` file, and click "Add"

4. Select the "Runner" project in the Project Navigator, then select the "Runner" target

5. Go to the "General" tab and scroll down to "Frameworks, Libraries, and Embedded Content"

6. Make sure the CastarSDK.framework is listed and its "Embed" option is set to "Embed & Sign"

## Step 3: Update Build Settings

1. Still in Xcode, with the "Runner" target selected, go to the "Build Settings" tab

2. Search for "Framework Search Paths"

3. Double-click on the value field and add `$(PROJECT_DIR)/Frameworks`

4. Search for "Other Linker Flags"

5. Add `-ObjC` to ensure all Objective-C classes from the framework are loaded

## Step 4: Update Podfile

1. Open the `ios/Podfile` file in a text editor

2. Make sure the iOS platform version is set to 12.0 or higher:
   ```ruby
   platform :ios, '12.0'
   ```

3. Add the CastarSDK pod reference inside the target block:
   ```ruby
   target 'Runner' do
     # ... existing content ...
     
     # Add CastarSDK framework
     pod 'CastarSDK', :path => 'Frameworks/CastarSDK.framework'
   end
   ```

4. Run pod install:
   ```bash
   cd ios && pod install
   ```

## Step 5: Run the Project

1. Build and run the project in Xcode to verify that the framework is correctly integrated

2. If you encounter any errors, check the following:
   - Make sure the framework is correctly added and embedded
   - Verify that the framework search paths are correctly set
   - Check that the minimum iOS deployment target is set to 12.0 or higher

## Troubleshooting

### Framework Not Found Error
If you get a "Framework not found" error, make sure:
- The framework is correctly copied to the Frameworks folder
- The framework search paths include `$(PROJECT_DIR)/Frameworks`
- The framework is added to the "Frameworks, Libraries, and Embedded Content" section

### Symbol Not Found Error
If you get a "Symbol not found" error, make sure:
- The `-ObjC` flag is added to "Other Linker Flags"
- The framework is compatible with your project's architecture settings

### Incompatible iOS Version
If you get warnings about iOS version compatibility, make sure:
- The minimum iOS deployment target is set to 12.0 or higher in both the project settings and Podfile 