import UIKit

// MARK: - UINavigationBar ()

extension UINavigationBar {

    // MARK: - Internal Methods

    @discardableResult
    func tintColor(_ palette: Palette) -> Self {
        tintColor = palette.uiColor
        return self
    }

    @discardableResult
    func barTintColor(_ palette: Palette) -> Self {
        barTintColor = palette.uiColor
        return self
    }

    @discardableResult
    func shadowColor(_ palette: Palette) -> Self {
        layer.shadowColor = palette.uiColor.cgColor
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

// MARK: - UINavigationBarAppearance ()

extension UINavigationBarAppearance {

    // MARK: - Internal Methods

    @discardableResult
    func titleAttributes(_ attributes: [TextAttributes]) -> Self {
        titleTextAttributes = attributes
            .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item  in
                dictionary[item.nsKey] = item.nsValue
            }
        return self
    }

    @discardableResult
    func largeTitleAttributes(_ attributes: [TextAttributes]) -> Self {
        largeTitleTextAttributes = attributes
            .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item  in
                dictionary[item.nsKey] = item.nsValue
            }
        return self
    }
}
