import UIKit

// MARK: - UILabel ()

extension UILabel {

    // MARK: - Internal Methods

    @discardableResult
    func textColor(_ palette: Palette) -> Self {
        textColor = palette.uiColor
        return self
    }

    @discardableResult
    func font(_ style: FontDecor) -> Self {
        font = style.uiFont
        return self
    }

    @discardableResult
    func titleAttributes(text: String, _ attributes: [TextAttributes]) -> Self {
        let attributes = attributes
            .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item  in
                dictionary[item.nsKey] = item.nsValue
            }
        attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )

        return self
    }
}
