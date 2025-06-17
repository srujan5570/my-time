# iOS Integration for CastarSDK

This guide will help you integrate CastarSDK into the iOS version of the My Time app.

## Prerequisites

- Xcode 15.3+
- iOS 12.0+
- CastarSDK.framework file (downloaded from CastarSDK developer portal)
- CocoaPods installed

## Setup Steps

1. **Download CastarSDK**
   - Download the CastarSDK from the developer portal
   - Unzip the downloaded file

2. **Add CastarSDK to the project**
   - Place the CastarSDK.framework in the `ios/Frameworks` directory
   - If the Frameworks directory doesn't exist, create it first

3. **Run the setup script**
   - For macOS/Linux: `./setup_castar_sdk.sh`
   - For Windows: `setup_castar_sdk.bat`

4. **Verify Integration**
   - Open the Xcode workspace: `open ios/Runner.xcworkspace`
   - Check that CastarSDK.framework is listed under Frameworks, Libraries, and Embedded Content
   - Ensure the Embed setting is set to "Embed & Sign"

## Manual Setup (if script fails)

1. **Add the framework to your project**
   - Open the Xcode project in the `ios` directory
   - Go to the project settings > General tab
   - Under "Frameworks, Libraries, and Embedded Content", click the + button
   - Select "Add Other..." and navigate to the CastarSDK.framework
   - Make sure "Embed & Sign" is selected

2. **Update Podfile**
   - Make sure your Podfile contains:
     ```ruby
     platform :ios, '12.0'
     
     target 'Runner' do
       use_frameworks!
       use_modular_headers!
       
       flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
       
       # Add CastarSDK framework
       pod 'CastarSDK', :path => 'Frameworks/CastarSDK.framework'
     end
     ```

3. **Install pods**
   - Run `pod install` in the `ios` directory

## Usage

The integration with Flutter is handled through method channels in the AppDelegate. The Flutter app can:

- Start the CastarSDK service by providing a client ID
- Stop the CastarSDK service

## Troubleshooting

1. **Framework not found**
   - Ensure CastarSDK.framework is in the correct location (ios/Frameworks)
   - Check that the framework is properly embedded in the Xcode project

2. **Build errors**
   - Make sure minimum iOS deployment target is set to 12.0
   - Verify that all required permissions are in Info.plist

3. **Runtime errors**
   - Check the console logs for any initialization errors
   - Verify that the client ID is valid

## Building for Distribution

To build the app for distribution:

```bash
flutter build ios --release
```

For a non-signed IPA (for testing):

```bash
flutter build ios --release --no-codesign
``` 