import Foundation
import SwiftUI

// MARK: - Palette

enum Palette: Hashable {
    case clear,
         black(_ alpha: CGFloat = 1),
         lightGray(_ alpha: CGFloat = 1),
         gray(_ alpha: CGFloat = 1),
         darkGray(_ alpha: CGFloat = 1),
         white(_ alpha: CGFloat = 1),
         blue(_ alpha: CGFloat = 1),
         green(_ alpha: CGFloat = 1),
         lightBlue(_ alpha: CGFloat = 1),
         tintBlue(_ alpha: CGFloat = 1),
         red(_ alpha: CGFloat = 1),
         beige(_ alpha: CGFloat = 1),
         custom(_ color: UIColor)

    // MARK: - Internal Properties

    var uiColor: UIColor {
        switch self {
        case .clear:
            return .clear
        case let .black(alpha):
            return #colorLiteral(red: 0.1019607843, green: 0.1803921569, blue: 0.2078431373, alpha: 1).withAlphaComponent(alpha)
        case let .gray(alpha):
            return #colorLiteral(red: 0.8078431373, green: 0.8274509804, blue: 0.8509803922, alpha: 1).withAlphaComponent(alpha)
        case let .lightGray(alpha):
            return #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9725490196, alpha: 1).withAlphaComponent(alpha)
        case let .white(alpha):
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(alpha)
        case let .blue(alpha):
            return #colorLiteral(red: 0.05490196078, green: 0.5568627451, blue: 0.9529411765, alpha: 1).withAlphaComponent(alpha)
        case let .green(alpha):
            return #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1).withAlphaComponent(alpha)
        case let .lightBlue(alpha):
            return #colorLiteral(red: 0.8117647059, green: 0.9098039216, blue: 0.9921568627, alpha: 1).withAlphaComponent(alpha)
        case let .tintBlue(alpha):
            return #colorLiteral(red: 0.9333333333, green: 0.9568627451, blue: 0.9843137255, alpha: 1).withAlphaComponent(alpha)
        case let .red(alpha):
            return #colorLiteral(red: 0.9098039216, green: 0.1176470588, blue: 0.3843137255, alpha: 1).withAlphaComponent(alpha)
        case let .beige(alpha):
            return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1).withAlphaComponent(alpha)
        case let .darkGray(alpha):
            return #colorLiteral(red: 0.462745098, green: 0.5098039216, blue: 0.5254901961, alpha: 1).withAlphaComponent(alpha)
        case let .custom(color):
            return color
        }
    }

    var suColor: Color { Color(uiColor) }

    var cgColor: CGColor { uiColor.cgColor }

    // MARK: - Internal Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(uiColor)
    }
}
