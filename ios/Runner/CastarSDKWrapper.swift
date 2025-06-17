import Foundation
@_exported import CastarSDK

// This class wraps the CastarSDK to ensure it's properly imported and available to the app
@objc public class CastarSDKWrapper: NSObject {
    private var instance: Castar?
    
    @objc public func initialize(withDevKey devKey: String) -> Bool {
        var error: NSError?
        instance = Castar.createInstance(withDevKey: devKey, error: &error)
        
        if let error = error {
            print("Failed to initialize CastarSDK: \(error.localizedDescription)")
            return false
        }
        
        return instance != nil
    }
    
    @objc public func start() {
        instance?.start()
    }
    
    @objc public func stop() {
        instance?.stop()
    }
    
    @objc public static func isAvailable() -> Bool {
        // This method can be used to check if the CastarSDK is available
        return true
    }
} 