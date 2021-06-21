import UIKit

// MARK: Alertable

protocol Alertable {
    func presentAlert(title: String?, message: String?, defaultButtonTitle: String?, completion: (() -> Void)?)
}

// MARK: - Alertable (UIViewController)
extension Alertable where Self: UIViewController {

    // MARK: - Public Methods

    func presentAlert(
        title: String?,
        message: String?,
        defaultButtonTitle: String? = "OK",
        completion: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = .blue

        if let title = title {
            let attributedString = NSAttributedString(string: title, attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.blue
            ])
            alertController.setValue(attributedString, forKey: "attributedTitle")
        }

        if let message = message {
            let attributedString = NSAttributedString(string: message, attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.blue
            ])
            alertController.setValue(attributedString, forKey: "attributedMessage")
        }

        alertController.addAction(UIAlertAction(title: defaultButtonTitle, style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true)
    }
}
