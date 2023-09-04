import UIKit

// MARK: - ButtonDecor

enum ButtonDecor {

    // MARK: - Types

    case black,
         gray,
         white

    // MARK: - Internal Properties

    var background: UIColor {
        switch self {
        case .black:
            return .chineseBlack
        case .gray:
            return .romanSilver
        case .white:
            return .clear
        }
    }

    var border: UIColor {
        switch self {
        case .black:
            return .clear
        case .gray:
            return .clear
        case .white:
            return .chineseBlack
        }
    }

    var fontColor: UIColor {
        switch self {
        case .black:
            return .white
        case .gray:
            return .chineseBlack04
        case .white:
            return .chineseBlack
        }
    }

    var backgroundImage: UIImage? {
        switch self {
        case .black:
            return UIImage().tintColor(.chineseBlack)
        case .gray:
            return UIImage().tintColor(.romanSilver)
        case .white:
            return nil
        }
    }
}
