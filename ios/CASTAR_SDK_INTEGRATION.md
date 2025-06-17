# CastarSDK Integration Guide for iOS

## Overview

This guide provides detailed steps to integrate the CastarSDK into your iOS app. The CastarSDK helps you monetize your app with minimal integration effort.

## Prerequisites

- iOS 12.0+
- Xcode 15.3+
- A valid CastarSDK Client ID (obtained from the developer portal)
- The CastarSDK framework file

## Step 1: Download the SDK

1. Go to the developer portal
2. Navigate to Applications -> Add
3. Create your Client ID for iOS
4. Download the SDK for iOS

## Step 2: Add the Framework to Your Project

1. Extract the downloaded ZIP file to get the `CastarSDK.framework` file
2. Copy the `CastarSDK.framework` file to the `ios/Frameworks/` directory in your project
3. Open your project in Xcode:
   ```
   cd ios
   open Runner.xcworkspace
   ```
4. In Xcode:
   - Select the "Runner" project in the Project Navigator
   - Select the "Runner" target
   - Go to the "General" tab
   - Scroll down to "Frameworks, Libraries, and Embedded Content"
   - Click the "+" button
   - Click "Add Other..." then "Add Files..."
   - Navigate to and select the `CastarSDK.framework` file in the Frameworks directory
   - Make sure "Embed & Sign" is selected in the "Embed" column

## Step 3: Update AppDelegate.swift

The `AppDelegate.swift` file has already been prepared with the necessary code, but some parts are commented out. You need to uncomment them:

1. Open `AppDelegate.swift`
2. Uncomment the import statement at the top:
   ```swift
   import CastarSDK
   ```
3. Uncomment the CastarSDK implementation in the `startService` method:
   ```swift
   // Set ClientId
   let key = clientId
               
   // Create a Castar instance
   let result = Castar.createInstance(devKey: key)
           
   switch result {
   case .success(let instance):
       // The instance is created and started
       self.castarInstance = instance
       instance.start()
       print("CastarSDK started successfully")
               
   case .failure(let error):
       // Handle errors
       print("Failed to initialize Castar: \(error.localizedDescription)")
   }
   ```
4. Uncomment the CastarSDK stop code in the `stopService` method:
   ```swift
   if let instance = castarInstance as? Castar {
       instance.stop()
       print("CastarSDK stopped")
   }
   ```

## Step 4: Test the Integration

1. Build and run the app
2. Enter your Client ID in the text field
3. Press "Start Service" to initialize and start the CastarSDK
4. Check the Xcode console for any error messages

## Troubleshooting

### Common Issues

1. **Framework not found**
   - Make sure the CastarSDK.framework is properly added to the project
   - Verify that it's set to "Embed & Sign" in the "Frameworks, Libraries, and Embedded Content" section

2. **Invalid Client ID**
   - Double-check that you're using the correct Client ID from the developer portal

3. **Build Errors**
   - If you encounter build errors related to architecture, make sure the framework supports the architecture you're building for (arm64, x86_64)

4. **Runtime Crashes**
   - Check if the SDK requires any additional permissions or settings
   - Verify that your deployment target is set to iOS 12.0 or higher

## Support

If you encounter any issues with the CastarSDK integration, please contact the CastarSDK support team for assistance. 