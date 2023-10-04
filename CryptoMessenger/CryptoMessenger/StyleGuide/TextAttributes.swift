import SwiftUI
import UIKit

// MARK: - TextAttributes

enum TextAttributes: Hashable {

    // MARK: - Types

    case color(Color)
    case font(Font)
    case paragraph(Paragraph)
    case kern(CGFloat)

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
            return color
        case let .font(font):
            return font
        case let .paragraph(value):
            return value.nsValue
        case let .kern(value):
            return value
        }
    }
}

// MARK: - Paragraph

struct Paragraph: Hashable {
    var nsValue: NSMutableParagraphStyle {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineHeightMultiple = lineHeightMultiple
        paragraph.lineBreakMode = .byWordWrapping
        return paragraph
    }

    let lineHeightMultiple: CGFloat
    let alignment: NSTextAlignment
}

// MARK: - NSAttributedString ()

extension NSAttributedString {

    // MARK: - Lifecycle

    convenience init(text: String, _ attributes: [TextAttributes]) {
        self.init(
            string: text,
            attributes: attributes
                    .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item in
                        dictionary[item.nsKey] = item.nsValue
                    }
        )
    }
}

// MARK: - Text ()

extension Text {

    // MARK: - Lifecycle

    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }

    init(_ string: String, _ attributes: [TextAttributes]) {
        var attributedString = AttributedString(string)
        let attributeContainer = AttributeContainer(
            attributes.reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item in
                dictionary[item.nsKey] = item.nsValue
            }
        )
        attributedString.setAttributes(attributeContainer)
        self.init(attributedString)
    }
}
