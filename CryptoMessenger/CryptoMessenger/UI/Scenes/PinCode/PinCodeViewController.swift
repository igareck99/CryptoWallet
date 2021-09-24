import LocalAuthentication
import UIKit

// MARK: - PinCodeViewController

final class PinCodeViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: PinCodePresentation!

    // MARK: - Private Properties

    private lazy var customView = PinCodeView(frame: UIScreen.main.bounds)
    private var localAuth = LocalAuthentication()
    @Injectable private var userFlows: UserFlowsStorageService

    private func setupLocalAuth() {
        localAuth.delegate = self
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapAuth = { [unowned self] in
            self.localAuth.authenticateWithBiometrics()
        }
        customView.didAuthSuccess = { [weak self] in
            let alert = UIAlertController(title: R.string.localizable.pinCodeAlertTitle(),
                                          message: R.string.localizable.pinCodeAlertMessage(),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.pinCodeAlertCancel(),
                                          style: UIAlertAction.Style.default,
                                          handler: { _ in
                                            self?.userFlows.isAuthFlowFinished = false }))
            alert.addAction(UIAlertAction(title: R.string.localizable.pinCodeAlertYes(),
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                                    self?.userFlows.isAuthFlowFinished = true
                    }))
            self?.present(alert, animated: true)
            self?.presenter.handleButtonTap()
        }
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalAuth()
        subscribeOnCustomViewActions()
        presenter.checkLocalAuth()
    }
}

// MARK: - PinCodeViewController (LocalAuthenticationDelegate)

extension PinCodeViewController: LocalAuthenticationDelegate {
    func didAuthenticate(_ success: Bool) {
        if success {
            customView.nextPage()
        }
    }
}

// MARK: - PinCodeViewController (PinCodeViewInterface)

extension PinCodeViewController: PinCodeViewInterface {
    func setLocalAuth(_ result: AvailableBiometrics?) {
        customView.setLocalAuth(result)
    }

    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
