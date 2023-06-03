import UIKit
import SwiftUI


extension Color{
    static var primaryColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white  })
        }
}
