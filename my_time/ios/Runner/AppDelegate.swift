import Flutter
import UIKit
import CastarSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var castarInstance: Castar?
  private static let CHANNEL = "com.example.my_time/service"
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup method channel for Flutter communication
    let controller = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: AppDelegate.CHANNEL, binaryMessenger: controller.binaryMessenger)
    
    methodChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      switch call.method {
      case "startService":
        if let clientId = call.arguments as? [String: Any],
           let id = clientId["clientId"] as? String {
          self.startCastarSdk(withClientId: id)
          result(true)
        } else {
          result(FlutterError(code: "NO_CLIENT_ID", message: "Client ID is null or empty", details: nil))
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
  
  private func startCastarSdk(withClientId clientId: String) {
    // Create a Castar instance with the provided client ID
    let result = Castar.createInstance(devKey: clientId)
    
    switch result {
    case .success(let instance):
      castarInstance = instance
      castarInstance?.start()
      print("CastarSDK started successfully with client ID: \(clientId)")
    case .failure(let error):
      print("Failed to initialize CastarSDK: \(error.localizedDescription)")
    }
  }
  
  private func stopCastarSdk() {
    castarInstance?.stop()
    print("CastarSDK stopped")
  }
}
