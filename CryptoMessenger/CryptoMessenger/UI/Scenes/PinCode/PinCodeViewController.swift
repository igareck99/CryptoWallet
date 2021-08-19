import LocalAuthentication
import UIKit

// MARK: - PinCodeViewController

final class PinCodeViewController: BaseViewController, LocalAuthenticationDelegate {

    // MARK: - Internal Properties

    var presenter: PinCodePresentation!

    // MARK: - Private Properties

    private lazy var customView = PinCodeView(frame: UIScreen.main.bounds)
    private var localAuth = LocalAuthentication()

    private func setupLocalAuth() {
        localAuth.delegate = self
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapAuth = { [unowned self] in
            self.localAuth.authenticateWithBiometrics()
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

    func didAuthenticate(_ success: Bool) {
        switch success {
        case true:
            customView.nextPage()
        default:
            break
        }
    }
}

// MARK: - PinCodeViewInterface

extension PinCodeViewController: PinCodeViewInterface {
    func setLocalAuth(_ result: AvailableBiometrics?) {
        customView.setLocalAuth(result)
    }

    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
