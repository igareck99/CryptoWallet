import Foundation
import SwiftUI

// MARK: - Palette

enum Palette: Hashable {
    case clear,
         black(_ alpha: CGFloat = 1),
         gray(_ alpha: CGFloat = 1),
         white(_ alpha: CGFloat = 1),
         purple(_ alpha: CGFloat = 1)

    // MARK: - Internal Properties

    var uiColor: UIColor {
        switch self {
        case .clear:
            return .clear
        case let .black(alpha):
            return .init(r: 61, g: 61, b: 61, a: alpha)
        case let .gray(alpha):
            return .init(r: 229, g: 229, b: 229, a: alpha)
        case let .white(alpha):
            return .init(r: 255, g: 255, b: 255, a: alpha)
        case let .purple(alpha):
            return .init(r: 230, g: 150, b: 254, a: alpha)
        }
    }

    var suColor: Color { Color(uiColor) }

    var cgColor: CGColor { uiColor.cgColor }

    // MARK: - Internal Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(uiColor)
    }
}
