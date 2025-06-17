import Flutter
import UIKit
import CastarSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var castarInstance: Castar?
  private let methodChannel = "com.example.my_time/service"
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup method channel for Flutter communication
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: methodChannel, binaryMessenger: controller.binaryMessenger)
    
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
    // Create a Castar instance with the client ID
    let result = Castar.createInstance(devKey: clientId)
    
    switch result {
    case .success(let instance):
      castarInstance = instance
      castarInstance?.start()
      print("CastarSDK started successfully")
    case .failure(let error):
      print("Failed to initialize CastarSDK: \(error.localizedDescription)")
    }
  }
  
  private func stopCastarSdk() {
    castarInstance?.stop()
    castarInstance = nil
    print("CastarSDK stopped")
  }
}
