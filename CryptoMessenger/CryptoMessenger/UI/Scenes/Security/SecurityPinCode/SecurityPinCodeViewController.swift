import UIKit

// MARK: SecurityPinCodeViewController

final class SecurityPinCodeViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: SecurityPinCodePresentation!

    // MARK: - Private Properties

    private lazy var customView = SecurityPinCodeView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        subscribeOnCustomViewActions()

    }

    private func subscribeOnCustomViewActions() {
        customView.didSetNewPinCode = { [unowned self] pinCode in
            presenter.setNewPinCode(pinCode)
            presenter.handleButtonTap(true)
            navigationController?.popViewController(animated: true)
        }
    }

}

// MARK: - SecurityPinCodeViewController (LocalAuthenticationDelegate)

extension SecurityPinCodeViewController: LocalAuthenticationDelegate {
    func didAuthenticate(_ success: Bool) {
        guard success else { return }
        customView.nextPage()
    }
}

// MARK: - SecurityPinCodeViewController (SecurityPinCodeViewInterface)

extension SecurityPinCodeViewController: SecurityPinCodeViewInterface {
    func setPinCode(_ pinCode: [Int]) {
        customView.setPinCode(pinCode)
    }

    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
