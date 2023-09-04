import UIKit

// MARK: - CGContext ()

extension CGContext {

    // MARK: - Internal Methods

    @discardableResult
    func setStrokeColor(_ color: UIColor) -> Self {
        setStrokeColor(color)
        return self
    }
}
