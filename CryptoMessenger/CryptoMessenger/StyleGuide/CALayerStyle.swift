import UIKit

// MARK: - CALayer ()

extension CALayer {

    // MARK: - Internal Methods

    @discardableResult
    func shadowColor(_ palette: Palette) -> Self {
        shadowColor = palette.cgColor
        return self
    }

    @discardableResult
    func borderColor(_ palette: Palette) -> Self {
        borderColor = palette.cgColor
        return self
    }

    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        borderWidth = width
        return self
    }
}
