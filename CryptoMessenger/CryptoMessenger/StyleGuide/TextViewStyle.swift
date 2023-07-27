import UIKit

// MARK: - UITextView ()

extension UITextView {

    // MARK: - Internal Methods

    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }

    @discardableResult
    func font(_ style: FontDecor) -> Self {
        font = style.uiFont
        return self
    }
}
