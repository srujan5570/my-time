# CastarSDK Integration Guide

This guide provides instructions on how to properly integrate the CastarSDK into your Flutter iOS app.

## Prerequisites

- iOS 12.0+
- Xcode 15.3+
- Flutter 3.0+

## Integration Steps

1. **Download the CastarSDK**
   - Download the CastarSDK.framework from the Castar developer portal
   - Unzip the file and place the CastarSDK.framework in the `ios/Frameworks` directory of your Flutter project

2. **Add the framework to your Xcode project**
   - Open your Xcode project by running `open ios/Runner.xcworkspace`
   - Select the Runner project in the Project Navigator
   - Go to the "General" tab
   - Scroll down to "Frameworks, Libraries, and Embedded Content"
   - Click the "+" button
   - Select "Add Other..." and navigate to the CastarSDK.framework file
   - Make sure "Embed & Sign" is selected in the Embed column

3. **Update your Podfile**
   - Add the following line to your Podfile in the target 'Runner' section:
     ```ruby
     pod 'CastarSDK', :path => '.'
     ```
   - Run `pod install` from the iOS directory

4. **Create a podspec file**
   - Create a file named `CastarSDK.podspec` in the iOS directory with the following content:
     ```ruby
     Pod::Spec.new do |s|
       s.name             = 'CastarSDK'
       s.version          = '1.0.0'
       s.summary          = 'CastarSDK for iOS'
       s.description      = 'CastarSDK SDK for iOS helps you make money with iOS apps.'
       s.homepage         = 'https://castar.com'
       s.license          = { :type => 'Commercial', :text => 'Copyright (c) 2024 Castar. All rights reserved.' }
       s.author           = { 'Castar' => 'support@castar.com' }
       s.source           = { :path => '.' }
       s.ios.deployment_target = '12.0'
       s.vendored_frameworks = 'Frameworks/CastarSDK.framework'
       s.frameworks = 'Foundation'
       s.swift_version = '5.0'
     end
     ```

5. **Import the CastarSDK in your AppDelegate**
   - Add the following import statement to your AppDelegate.swift file:
     ```swift
     import CastarSDK
     ```

6. **Initialize and use the CastarSDK**
   - Initialize the CastarSDK with your client ID
   - Start the SDK when needed
   - Stop the SDK when needed

## Troubleshooting

If you encounter the error "No such module 'CastarSDK'", try the following:

1. Clean your project by running `flutter clean` and `cd ios && pod install`
2. Make sure the CastarSDK.framework is in the correct location
3. Check that the framework is properly linked in Xcode
4. Make sure the framework is properly embedded in your app

## Example Usage

```swift
import CastarSDK

// Set ClientId
let key = "YOUR_CLIENT_ID"
            
// Create a Castar instance
let result = Castar.createInstance(devKey: key)
        
switch result {
case .success(let castarInstance):
    // The instance is created and started
    castarInstance.start()
            
case .failure(let error):
    // Handle errors
    print("Failed to initialize Castar: \(error.localizedDescription)")
}
``` 