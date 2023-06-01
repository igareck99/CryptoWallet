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

extension Color{
    static var primaryColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white  })
        }
}
