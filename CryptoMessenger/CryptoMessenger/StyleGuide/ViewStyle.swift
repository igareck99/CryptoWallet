import SwiftUI
import UIKit

// MARK: - UIView ()

extension UIView {

    // MARK: - Internal Methods

    @discardableResult
    func background(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }

    func backgroundColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    func tint(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
}

extension View {

    // MARK: - Internal Methods

    func background(_ palette: Palette) -> some View {
        background(palette.suColor)
    }

    func foreground(_ color: Color) -> some View {
        foregroundColor(color)
    }

    func font(_ style: FontDecor) -> some View {
        font(style.suFont)
    }
}
