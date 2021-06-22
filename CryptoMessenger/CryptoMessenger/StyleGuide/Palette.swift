import Foundation
import SwiftUI

// MARK: - Palette

enum Palette: Hashable {
    case clear,
         black(_ alpha: CGFloat = 1),
         lightGray(_ alpha: CGFloat = 1),
         gray(_ alpha: CGFloat = 1),
         white(_ alpha: CGFloat = 1),
         blue(_ alpha: CGFloat = 1)

    // MARK: - Internal Properties

    var uiColor: UIColor {
        switch self {
        case .clear:
            return .clear
        case let .black(alpha):
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(alpha)
        case let .gray(alpha):
            return #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1).withAlphaComponent(alpha)
        case let .lightGray(alpha):
            return #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9725490196, alpha: 1).withAlphaComponent(alpha)
        case let .white(alpha):
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(alpha)
        case let .blue(alpha):
            return #colorLiteral(red: 0.2431372549, green: 0.6039215686, blue: 0.8862745098, alpha: 1).withAlphaComponent(alpha)
        }
    }

    var suColor: Color { Color(uiColor) }

    var cgColor: CGColor { uiColor.cgColor }

    // MARK: - Internal Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(uiColor)
    }
}
