import UIKit

// MARK: - UINavigationBar ()

extension UINavigationBar {

    // MARK: - Internal Methods

    @discardableResult
    func barTintColor(_ palette: Palette) -> Self {
        barTintColor = palette.uiColor
        return self
    }

    @discardableResult
    func tintColor(_ palette: Palette) -> Self {
        tintColor = palette.uiColor
        return self
    }

    @discardableResult
    func titleAttributes(_ attributes: [TextAttributes]) -> Self {
        titleTextAttributes = attributes
            .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item  in
                dictionary[item.nsKey] = item.nsValue
            }
        return self
    }
}