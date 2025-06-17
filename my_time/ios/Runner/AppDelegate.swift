import Flutter
import UIKit
import CastarSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var castarInstance: Castar?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.my_time/service", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }
      
      switch call.method {
      case "startService":
        guard let args = call.arguments as? [String: Any],
              let clientId = args["clientId"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "Client ID is required",
                            details: nil))
          return
        }
        
        let castarResult = Castar.createInstance(devKey: clientId)
        switch castarResult {
        case .success(let instance):
          self.castarInstance = instance
          instance.start()
          result(nil)
        case .failure(let error):
          result(FlutterError(code: "CASTAR_ERROR",
                            message: error.localizedDescription,
                            details: nil))
        }
        
      case "stopService":
        self.castarInstance?.stop()
        self.castarInstance = nil
        result(nil)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
