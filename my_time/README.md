# My Time

A Flutter application that integrates with CastarSDK for both Android and iOS platforms to track time and display uptime.

## Features

- Client ID input for CastarSDK initialization
- Start/Stop functionality for CastarSDK service
- Real-time uptime tracking with HH:MM:SS format display
- IP information display with location details
- Vibration notification after 6 minutes of uptime

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode
- CastarSDK for Android (.aar file)
- CastarSDK for iOS (.framework file)

### Android Setup

1. Place the `CastarSdk.aar` file in the `android/app/libs/` directory
2. The project is already configured to use the SDK with:
   - Method channel for Flutter-Native communication
   - CastarSdk integration in MainActivity.kt and MyApplication.kt
   - Internet permissions in AndroidManifest.xml
   - minSdk set to 24 for compatibility

### iOS Setup

1. Download the CastarSDK.framework file from the developer portal
2. Follow one of these methods to integrate:

#### Automated Setup (Recommended)
1. Navigate to the iOS directory:
   ```
   cd ios
   ```
2. Run the setup script:
   ```
   ./setup_castarsdk.sh /path/to/CastarSDK.framework
   ```
3. Open the Xcode workspace and verify the integration:
   ```
   open Runner.xcworkspace
   ```

#### Manual Setup
1. Follow the detailed instructions in `ios/MANUAL_SETUP.md`

## Usage

1. Launch the app
2. Enter your CastarSDK Client ID
3. Press "Start CastarSDK" to begin tracking time
4. The uptime will be displayed in HH:MM:SS format
5. Press "Stop CastarSDK" to stop the service

## GitHub Actions

The project includes GitHub Actions workflows for both Android and iOS builds:

- Android: Builds an APK file
- iOS: Builds an IPA file without code signing (for testing purposes)

To use the GitHub Actions workflows, push your changes to the repository and the workflows will run automatically.

## Troubleshooting

If you encounter issues with the CastarSDK integration:

- For Android, check the `android/app/build.gradle.kts` file for proper dependencies
- For iOS, refer to the troubleshooting section in `ios/MANUAL_SETUP.md`

## Dependencies

- flutter/material.dart - UI components
- flutter/services.dart - Method channel for native communication
- http - For IP information fetching
- firebase_core & cloud_firestore - For IP uniqueness checking
- vibration - For vibration notifications
- CastarSDK - Native SDK for Android and iOS
