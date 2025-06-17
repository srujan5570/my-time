# CastarSDK Integration for iOS

## Setup Instructions

1. Download the CastarSDK from the developer portal
2. Extract the downloaded file and locate the `CastarSDK.framework` file
3. Copy the `CastarSDK.framework` file into this directory (`ios/Frameworks/`)
4. Open the Xcode project:
   ```
   cd ios
   open Runner.xcworkspace
   ```
5. In Xcode:
   - Select the "Runner" project in the Project Navigator
   - Select the "Runner" target
   - Go to the "General" tab
   - Scroll down to "Frameworks, Libraries, and Embedded Content"
   - Click the "+" button
   - Click "Add Other..." then "Add Files..."
   - Navigate to and select the `CastarSDK.framework` file in the Frameworks directory
   - Make sure "Embed & Sign" is selected in the "Embed" column

6. Uncomment the relevant code in `AppDelegate.swift`:
   - Uncomment the `import CastarSDK` line at the top
   - Uncomment the CastarSDK implementation in the `startService` method
   - Uncomment the CastarSDK stop code in the `stopService` method

## Usage

The app is already set up to use the CastarSDK:
1. Enter your Client ID in the text field
2. Press "Start Service" to initialize and start the CastarSDK
3. Press "Stop Service" to stop the CastarSDK when needed

## Requirements

- iOS 12.0+
- Xcode 15.3+ 