import Foundation
import SwiftUI

// MARK: - FontDecor

enum FontDecor: Hashable {
    case light(CGFloat),
         regular(CGFloat),
         medium(CGFloat),
         semibold(CGFloat),
         bold(CGFloat)

    // MARK: - Internal Properties

    var uiFont: UIFont {
        switch self {
        case .light(let size):
            return light(ofSize: size)
        case .regular(let size):
            return regular(ofSize: size)
        case .medium(let size):
            return medium(ofSize: size)
        case .semibold(let size):
            return semibold(ofSize: size)
        case .bold(let size):
            return bold(ofSize: size)
        }
    }

    var suFont: Font { Font(uiFont) }

    // MARK: - Private Methods

    private func light(ofSize size: CGFloat) -> UIFont {
        //return UIFont(name: "Rubik-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
        return .systemFont(ofSize: size, weight: .light)
    }

    private func regular(ofSize size: CGFloat) -> UIFont {
        //return UIFont(name: "Rubik-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
        return .systemFont(ofSize: size, weight: .regular)
    }

    private func medium(ofSize size: CGFloat) -> UIFont {
        //return UIFont(name: "Rubik-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
        return .systemFont(ofSize: size, weight: .medium)
    }

    private func semibold(ofSize size: CGFloat) -> UIFont {
        //return UIFont(name: "Rubik-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        return .systemFont(ofSize: size, weight: .semibold)
    }

    private func bold(ofSize size: CGFloat) -> UIFont {
        //return UIFont(name: "Rubik-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        return .systemFont(ofSize: size, weight: .bold)
    }
}
