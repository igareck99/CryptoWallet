import UIKit

// MARK: - TextAttributes

enum TextAttributes: Hashable {
    case color(Palette)
    case font(FontDecor)
    case paragraph(NSMutableParagraphStyle)

    // MARK: - Internal Properties

    var nsKey: NSAttributedString.Key {
        switch self {
        case .color:
            return .foregroundColor
        case .font:
            return .font
        case .paragraph:
            return .paragraphStyle
        }
    }

    var nsValue: Any {
        switch self {
        case let .color(color):
            return color.uiColor
        case let .font(font):
            return font.uiFont
        case let .paragraph(value):
            return value
        }
    }
}
