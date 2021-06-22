import UIKit

// MARK: - CGContext ()

extension CGContext {

    // MARK: - Internal Methods

    @discardableResult
    func setStrokeColor(_ palette: Palette) -> Self {
        setStrokeColor(palette.cgColor)
        return self
    }
}
