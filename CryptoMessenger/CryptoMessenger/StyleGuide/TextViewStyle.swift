import UIKit

// MARK: - UITextView ()

extension UITextView {

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
}
