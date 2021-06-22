import UIKit

// MARK: - UISwitch ()

extension UISwitch {

    // MARK: - Internal Methods

    @discardableResult
    func onTintColor(_ palette: Palette) -> Self {
        onTintColor = palette.uiColor
        return self
    }
}
