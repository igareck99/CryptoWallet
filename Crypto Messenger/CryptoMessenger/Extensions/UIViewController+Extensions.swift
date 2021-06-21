import UIKit

// MARK: UIViewController (Alertable)

extension UIViewController: Alertable {}

// MARK: - UIViewController ()

extension UIViewController {

    // MARK: - Internal Methods

    final func addDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Actions

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
