import UIKit

// MARK: - ButtonDecor

enum ButtonDecor {

    // MARK: - Types

    case black,
         gray,
         white

    // MARK: - Internal Properties

    var background: Palette {
        switch self {
        case .black:
            return .black()
        case .gray:
            return .gray()
        case .white:
            return .clear
        }
    }

    var border: Palette {
        switch self {
        case .black:
            return .clear
        case .gray:
            return .clear
        case .white:
            return .black()
        }
    }

    var fontColor: Palette {
        switch self {
        case .black:
            return .white()
        case .gray:
            return .black(0.3)
        case .white:
            return .black()
        }
    }

    var backgroundImage: UIImage? {
        switch self {
        case .black:
            return UIImage().tintColor(.black())
        case .gray:
            return UIImage().tintColor(.gray())
        case .white:
            return nil
        }
    }
}
