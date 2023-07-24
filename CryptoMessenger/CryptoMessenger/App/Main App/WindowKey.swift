import SwiftUI
import UIKit

struct WindowKey: EnvironmentKey {
    typealias Value = UIWindow?
    static var defaultValue: UIWindow?
}

extension EnvironmentValues {
    
    var window: UIWindow? {
        get {
            self[WindowKey.self]
        }
        set {
            self[WindowKey.self] = newValue
        }
    }
}
