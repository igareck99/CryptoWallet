import LocalAuthentication
import UIKit

// MARK: - PinCodeViewController

final class PinCodeViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: PinCodePresentation!

    // MARK: - Private Properties

    private lazy var customView = PinCodeView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupLocalAuth()
        subscribeOnCustomViewActions()
        presenter.checkLocalAuth()
    }

    // MARK: - Private Methods

    private func setupLocalAuth() {
        presenter.localAuth.delegate = self
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapAuth = { [unowned self] in
			let reason = presenter.localAuth.biometryAppEnterReasonText()
			presenter.localAuth.authenticateWithBiometrics(reason: reason)
        }
        customView.didAuthSuccess = { [unowned self] in
            guard presenter.isLocalAuthBackgroundAlertShown == false else {
                presenter.handleButtonTap(false)
                return
            }
            self.showLocalAuthAlert()
        }
        customView.didSetNewPinCode = { [unowned self] pinCode in
            presenter.setNewPinCode(pinCode)
            presenter.handleButtonTap(false)
        }
    }

    private func showLocalAuthAlert() {
        let alert = UIAlertController(
            title: R.string.localizable.pinCodeAlertTitle(),
            message: R.string.localizable.pinCodeAlertMessage(),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.pinCodeAlertCancel(),
                style: .default
            ) { _ in
                self.presenter.handleButtonTap(false)
            }
        )
        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.pinCodeAlertYes(),
                style: .default
            ) { _ in
                self.presenter.handleButtonTap(true)
            }
        )
        present(alert, animated: true)
    }
}

// MARK: - PinCodeViewController (LocalAuthenticationDelegate)

extension PinCodeViewController: LocalAuthenticationDelegate {
    func didAuthenticate(_ success: Bool) {
        guard success else { return }
        customView.nextPage()
    }
}

// MARK: - PinCodeViewController (PinCodeViewInterface)

extension PinCodeViewController: PinCodeViewInterface {

    func setPinCode(_ pinCode: [Int]) {
        customView.setPinCode(pinCode)
    }

    func setLocalAuth(_ result: AvailableBiometric) {
        customView.setLocalAuth(result)
    }

    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }

    func setBiometryActive(_ result: Bool) {
        customView.setBiometryActive(result)
    }

	func shouldHideCantEnter(isHiddedn: Bool) {
		customView.setEnterActive(isHiddedn)
	}
}
