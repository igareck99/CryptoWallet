import UIKit

// MARK: - UIImage ()

extension UIImage {

    // MARK: - Internal Methods

    @discardableResult
    func tintColor(_ palette: Palette) -> UIImage {
        withTintColor(palette.uiColor)
    }

    @discardableResult
    func withTintColor(_ palette: Palette, renderingMode: UIImage.RenderingMode) -> UIImage {
        withTintColor(palette.uiColor, renderingMode: renderingMode)
    }
}
