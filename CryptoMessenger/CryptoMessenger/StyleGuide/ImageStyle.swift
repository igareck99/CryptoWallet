import UIKit
import SwiftUI
// MARK: - UIImage ()

extension UIImage {

    // MARK: - Internal Methods

    @discardableResult
    func tintColor(_ color: Color) -> UIImage {
        withTintColor(UIColor(color))
    }

    @discardableResult
    func withTintColor(_ color: Color, renderingMode: UIImage.RenderingMode) -> UIImage {
        withTintColor(color, renderingMode: renderingMode)
    }
}
