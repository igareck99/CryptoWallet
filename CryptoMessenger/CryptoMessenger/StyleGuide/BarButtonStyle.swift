import UIKit

// MARK: - UIBarButtonItem ()

extension UIBarButtonItem {

    // MARK: - Internal Methods

    @discardableResult
    func titleAttributes(_ attributes: [TextAttributes], for state: UIControl.State) -> Self {
        let titleTextAttributes = attributes
            .reduce(into: [NSAttributedString.Key: Any]()) { dictionary, item  in
                dictionary[item.nsKey] = item.nsValue
            }
        setTitleTextAttributes(titleTextAttributes, for: state)
        return self
    }
}
