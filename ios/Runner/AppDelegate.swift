import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var serviceTimer: Timer?
  private var clientId: String?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.my_time/service", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      switch call.method {
      case "startService":
        if let args = call.arguments as? [String: Any],
           let clientId = args["clientId"] as? String {
          self.startService(clientId: clientId)
          result(true)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
      case "stopService":
        self.stopService()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func startService(clientId: String) {
    self.clientId = clientId
    print("Service started with client ID: \(clientId)")
    
    // In a real implementation, you would initialize CastarSdk here
    // For now, we'll just set up a simple timer to simulate the service
    serviceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      print("Service running with client ID: \(self.clientId ?? "unknown")")
    }
  }
  
  private func stopService() {
    serviceTimer?.invalidate()
    serviceTimer = nil
    clientId = nil
    print("Service stopped")
  }
}
