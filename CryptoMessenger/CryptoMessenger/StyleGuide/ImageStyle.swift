import UIKit

// MARK: - UIImage ()

extension UIImage {

    // MARK: - Internal Methods

    @discardableResult
    func tintColor(_ palette: Palette) -> UIImage {
        withTintColor(palette.uiColor)
    }
}
