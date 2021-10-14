import UIKit

// MARK: - TextAttributes

enum TextAttributes: Hashable {
    case color(Palette)
    case font(FontDecor)
    case paragraph(NSMutableParagraphStyle)
    case kern(Double)

    // MARK: - Internal Properties

    var nsKey: NSAttributedString.Key {
        switch self {
        case .color:
            return .foregroundColor
        case .font:
            return .font
        case .paragraph:
            return .paragraphStyle
        case .kern:
            return .kern
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
        case let .kern(value):
            return value
        }
    }
}

// MARK: - NSMutableParagraphStyle ()

extension NSMutableParagraphStyle {

    // MARK: - Lifecycle

    convenience init(alignment: NSTextAlignment, _ lineHeightMultiple: CGFloat) {
        self.init()
        self.alignment = alignment
        self.lineHeightMultiple = lineHeightMultiple
    }
}
