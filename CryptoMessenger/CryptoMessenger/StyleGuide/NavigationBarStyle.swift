import UIKit

// MARK: - UINavigationBar ()

extension UINavigationBar {

    // MARK: - Internal Methods

    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    func barTintColor(_ color: UIColor) -> Self {
        barTintColor = color
        return self
    }

    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        layer.shadowColor = color.cgColor
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
