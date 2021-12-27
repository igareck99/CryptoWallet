import UIKit

// MARK: - TypographyItemCase

enum TypographyItemCase {

    // MARK: - Types

    case little
    case middle
    case big
    case standart

    // MARK: - Internal Properties

    var name: String {
        switch self {
        case .little:
            return R.string.localizable.typographyLittleTitle()
        case .middle:
            return R.string.localizable.typographyMiddleTitle()
        case .big:
            return R.string.localizable.typographyBigTitle()
        case .standart:
            return "Управление...ом шрифта"
        }
    }

    var sizeTitle: String {
        switch self {
        case .little:
            return R.string.localizable.typographyLittleSize()
        case .middle:
            return R.string.localizable.typographyMiddleSize()
        case .big:
            return R.string.localizable.typographyBigSize()
        case .standart:
            return "Стандартный"
        }
    }

    var bigSize: CGFloat {
        switch self {
        case .little:
            return 15
        case .middle:
            return 20
        case .big:
            return 25
        case .standart:
            return 15
        }
    }

    var littleSize: CGFloat {
        switch self {
        case .little:
            return 13
        case .middle:
            return 16
        case .big:
            return 19
        case .standart:
            return 13
        }
    }
}

// MARK: - TypographyNewItem

struct TypographyNewItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: TypographyItemCase
}
