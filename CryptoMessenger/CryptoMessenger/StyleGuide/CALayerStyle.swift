import UIKit

// MARK: - CALayer ()

extension CALayer {

    // MARK: - Internal Methods

    @discardableResult
    func shadowColor(_ palette: Palette) -> Self {
        shadowColor = palette.cgColor
        return self
    }
}
