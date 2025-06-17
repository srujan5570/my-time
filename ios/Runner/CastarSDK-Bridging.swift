import Foundation

// This file ensures CastarSDK is properly imported and available to the app

@objc public class CastarSDKBridge: NSObject {
    @objc public static func frameworkVersion() -> String {
        return "1.0.0"
    }
} 