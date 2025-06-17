import Flutter
import UIKit
// Import CastarSDK
import CastarSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var serviceTimer: Timer?
  private var clientId: String?
  // This will hold the Castar instance
  private var castarInstance: Any?
  
  // Make the Flutter engine available to SceneDelegate
  lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Flutter engine
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)
    
    // Set up method channel
    let methodChannel = FlutterMethodChannel(
      name: "com.example.my_time/service",
      binaryMessenger: flutterEngine.binaryMessenger
    )
    
    methodChannel.setMethodCallHandler { [weak self] (call, result) in
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
    
    // Create necessary directories for CoreFSCache
    createCacheDirectories()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Create necessary directories for CoreFSCache
  private func createCacheDirectories() {
    let fileManager = FileManager.default
    let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    let cacheDirectory = "\(libraryDirectory)/Caches"
    let coreFSCacheDirectory = "\(cacheDirectory)/com.apple.CoreFSCache"
    
    do {
      // Create Caches directory if it doesn't exist
      if !fileManager.fileExists(atPath: cacheDirectory) {
        try fileManager.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
      }
      
      // Create CoreFSCache directory if it doesn't exist
      if !fileManager.fileExists(atPath: coreFSCacheDirectory) {
        try fileManager.createDirectory(atPath: coreFSCacheDirectory, withIntermediateDirectories: true, attributes: nil)
      }
      
      print("Cache directories created successfully")
    } catch {
      print("Error creating cache directories: \(error)")
    }
  }
  
  // Add UIScene lifecycle support
  override func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    configuration.delegateClass = SceneDelegate.self
    return configuration
  }
  
  override func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // Called when the user discards a scene session
  }
  
  private func startService(clientId: String) {
    self.clientId = clientId
    print("Service started with client ID: \(clientId)")
    
    // CastarSDK implementation
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
        
        // Fall back to timer simulation if CastarSDK fails
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
