import Foundation
import CastarSDK

extension Castar {
    static func createInstance(devKey: String) -> Result<Castar, Error> {
        var error: NSError?
        let instance = Castar.createInstance(withDevKey: devKey, error: &error)
        
        if let error = error {
            return .failure(error)
        }
        
        if let instance = instance {
            return .success(instance)
        } else {
            return .failure(NSError(domain: "CastarSDK", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create Castar instance"]))
        }
    }
} 