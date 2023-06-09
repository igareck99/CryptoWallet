import RswiftResources
import SwiftUI
import UIKit

// MARK: - ImageResource ()

extension ImageResource {
    var image: Image { Image(name) }
	var imageNamed: UIImage? { UIImage(named: name) }
}

// MARK: - ColorResource ()

extension ColorResource {
    var color: Color { Color(name) }
}

// MARK: - FontResource ()

extension FontResource {
    func font(size: CGFloat) -> Font { .custom(name, size: size) }
}

// MARK: - Color ()

//extension Color{
//    static var primaryColor: Color {
//        Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white  })
//        }
//}

extension Color {
    static var customtheme = 0
    static var primaryColor: Color {
        Color(customtheme != 3 ? UIColor { $0.userInterfaceStyle == .dark ? .black : .white  }: .green)
    }
}
