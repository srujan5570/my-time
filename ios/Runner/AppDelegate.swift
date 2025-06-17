import Flutter
import UIKit
// Import CastarSDK using @_exported to make it available to other files
@_exported import CastarSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var serviceTimer: Timer?
  private var clientId: String?
  // This will hold the Castar instance when the framework is available
  private var castarInstance: Any?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register plugins first to ensure proper initialization
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup method channel after plugin registration
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
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func startService(clientId: String) {
    self.clientId = clientId
    print("Service started with client ID: \(clientId)")
    
    // CastarSDK implementation
    // Using the actual CastarSDK implementation now
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
        
        // Fallback to timer-based simulation if CastarSDK fails
        serviceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
          guard let self = self else { return }
          print("Service running with client ID: \(self.clientId ?? "unknown")")
        }
    }
  }
  
  private func stopService() {
    // Stop CastarSDK if it's running
    if let instance = castarInstance as? Castar {
        instance.stop()
        print("CastarSDK stopped")
    }
    
    serviceTimer?.invalidate()
    serviceTimer = nil
    castarInstance = nil
    clientId = nil
    print("Service stopped")
  }
}
