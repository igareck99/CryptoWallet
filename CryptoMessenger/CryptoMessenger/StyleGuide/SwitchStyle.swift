import UIKit

// MARK: - UISwitch ()

extension UISwitch {

    // MARK: - Internal Methods

    @discardableResult
    func onTintColor(_ color: UIColor) -> Self {
        onTintColor = color
        return self
    }
}
