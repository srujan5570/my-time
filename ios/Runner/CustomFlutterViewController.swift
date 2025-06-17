import Flutter
import UIKit

class CustomFlutterViewController: FlutterViewController {
    // Override the focusItemsInRect method to fix the warning
    override func focusItemsInRect(_ rect: CGRect) -> [UIFocusItem] {
        // Return an empty array to avoid the warning
        return []
    }
} 