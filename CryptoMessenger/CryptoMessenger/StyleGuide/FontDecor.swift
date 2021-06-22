import Foundation
import SwiftUI

// MARK: - FontDecor

enum FontDecor: Hashable {
    case medium(CGFloat),
         regular(CGFloat),
         light(CGFloat)

    // MARK: - Internal Properties

    var uiFont: UIFont {
        switch self {
        case .medium(let size):
            return medium(ofSize: size)
        case .regular(let size):
            return regular(ofSize: size)
        case .light(let size):
            return light(ofSize: size)
        }
    }

    var suFont: Font { Font(uiFont) }

    // MARK: - Private Methods

    private func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "DINPro-Medium", size: size) ?? .boldSystemFont(ofSize: size)
    }

    private func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "DINPro-Regular", size: size) ?? .systemFont(ofSize: size)
    }

    private func light(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "DINPro-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
    }
}
