import SwiftUI
import UIKit

// MARK: - UIView ()

extension UIView {

    // MARK: - Internal Methods

    @discardableResult
    func background(_ palette: Palette?) -> Self {
        backgroundColor = palette?.uiColor
        return self
    }

    @discardableResult
    func tint(_ palette: Palette) -> Self {
        tintColor = palette.uiColor
        return self
    }
}

extension View {

    // MARK: - Internal Methods

    func background(_ palette: Palette) -> some View {
        background(palette.suColor)
    }

    func foreground(_ palette: Palette) -> some View {
        foregroundColor(palette.suColor)
    }

    func font(_ style: FontDecor) -> some View {
        font(style.suFont)
    }
}
