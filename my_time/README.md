# My Time

A Flutter application that integrates with CastarSdk for both Android and iOS.

## Features

- Client ID input
- Start/Stop CastarSdk service
- Uptime display (HH:MM:SS format)
- IP information display
- Vibration notifications

## CastarSDK Integration

### Android Integration

1. Add the CastarSdk.aar file to the `android/app/libs` directory
2. Update `android/app/build.gradle.kts` to include the AAR dependency:
   ```kotlin
   dependencies {
       implementation(files("libs/CastarSdk.aar"))
   }
   ```
3. Update `AndroidManifest.xml` to add required permissions:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   ```
4. Create a custom Application class to initialize the SDK:
   ```kotlin
   class MyApplication : Application() {
       override fun onCreate() {
           super.onCreate()
           // CastarSdk initialization will be done when requested
       }
   }
   ```
5. Implement the MethodChannel in MainActivity to communicate with Flutter:
   ```kotlin
   private val CHANNEL = "com.example.my_time/service"
   
   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
       super.configureFlutterEngine(flutterEngine)
       MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
           when (call.method) {
               "startService" -> {
                   val clientId = call.argument<String>("clientId")
                   if (clientId != null) {
                       CastarSdk.init(this, clientId)
                       CastarSdk.start()
                       result.success(true)
                   } else {
                       result.error("INVALID_ARGUMENTS", "Client ID is required", null)
                   }
               }
               "stopService" -> {
                   CastarSdk.stop()
                   result.success(true)
               }
               else -> result.notImplemented()
           }
       }
   }
   ```

### iOS Integration

1. Add the CastarSDK.framework to the `ios/Frameworks` directory
2. Update the Podfile to include the framework:
   ```ruby
   platform :ios, '12.0'
   
   target 'Runner' do
     use_frameworks!
     
     flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
     
     # Add CastarSDK framework
     pod 'CastarSDK', :path => 'Frameworks/CastarSDK.framework'
   end
   ```
3. Update Info.plist to add required permissions:
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
   </dict>
   <key>UIBackgroundModes</key>
   <array>
     <string>fetch</string>
     <string>processing</string>
   </array>
   ```
4. Implement the MethodChannel in AppDelegate to communicate with Flutter:
   ```swift
   import Flutter
   import UIKit
   import CastarSDK
   
   @objc class AppDelegate: FlutterAppDelegate {
     private var castarInstance: Castar?
     
     override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       let controller = window?.rootViewController as! FlutterViewController
       let channel = FlutterMethodChannel(name: "com.example.my_time/service", binaryMessenger: controller.binaryMessenger)
       
       channel.setMethodCallHandler { [weak self] (call, result) in
         guard let self = self else { return }
         
         switch call.method {
         case "startService":
           if let args = call.arguments as? [String: Any],
              let clientId = args["clientId"] as? String {
             self.startCastarSdk(clientId: clientId)
             result(true)
           } else {
             result(FlutterError(code: "INVALID_ARGUMENTS", message: "Client ID is required", details: nil))
           }
         case "stopService":
           self.stopCastarSdk()
           result(true)
         default:
           result(FlutterMethodNotImplemented)
         }
       }
       
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
     
     private func startCastarSdk(clientId: String) {
       let result = Castar.createInstance(devKey: clientId)
       
       switch result {
       case .success(let instance):
         castarInstance = instance
         castarInstance?.start()
       case .failure(let error):
         print("Failed to initialize CastarSDK: \(error.localizedDescription)")
       }
     }
     
     private func stopCastarSdk() {
       castarInstance?.stop()
       castarInstance = nil
     }
   }
   ```

## Building the App

### Android Build
```
flutter build apk --release
```

### iOS Build
```
cd ios
pod install
cd ..
flutter build ios --release --no-codesign
```

## GitHub Actions Workflow

The project includes GitHub Actions workflows for automated builds:

### Automatic Builds
Every push to the `master` or `main` branch automatically triggers:
- Android APK build
- iOS IPA build

These builds are available as artifacts in the GitHub Actions tab.

### Release Builds
For versioned releases with proper tags, use the release workflow:

1. **Tag-based release**:
   ```bash
   git tag v1.0.0
   git push --tags
   ```

2. **Manual release**:
   - Go to Actions tab in GitHub
   - Select "Release Build" workflow
   - Click "Run workflow"
   - Enter version number (e.g., "1.0.0")
   - Click "Run workflow"

The release workflow creates a proper GitHub release with both APK and IPA files attached.
