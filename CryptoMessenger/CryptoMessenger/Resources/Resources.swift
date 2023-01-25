import RswiftResources
import SwiftUI

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
