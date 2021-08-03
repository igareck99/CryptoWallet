import SwiftUI
import UIKit

// MARK: - UIButton ()

extension UIButton {

    // MARK: - Internal Methods

    @discardableResult
    func decor(_ btnDecor: ButtonDecor) -> Self {
        layer.borderColor = btnDecor.border.cgColor
        setTitleColor(btnDecor.fontColor.uiColor, for: .normal)
        setBackgroundImage(btnDecor.backgroundImage, for: .normal)
        return self
    }

    @discardableResult
    func font(_ fontstyle: FontDecor) -> Self {
        titleLabel?.font = fontstyle.uiFont
        return self
    }

    @discardableResult
    func titleAttributes(text: String, _ attributes: [TextAttributes]) -> Self {
        let attributes = attributes
            .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item  in
                dictionary[item.nsKey] = item.nsValue
            }

        let attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )

        setAttributedTitle(attributedText, for: .normal)

        return self
    }
}

extension Button {

    // MARK: - Static Methods

    static func get(text: String, action: @escaping () -> Void, decor: ButtonDecor) -> some View {
        Button<Text>(action: action) {
            Text(text)
        }
        .decor(decor)
    }

    // MARK: - Internal Methods

    func decor(_ btnDecor: ButtonDecor) -> some View {
        frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foreground(btnDecor.fontColor)
            .padding(5)
            .background(btnDecor.background)
            .cornerRadius(40)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(btnDecor.border.suColor, lineWidth: 1)
            )
    }
}
