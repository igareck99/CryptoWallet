import LocalAuthentication
import UIKit

// MARK: - PinCodeViewController

final class PinCodeViewController: BaseViewController {
    // MARK: - Internal Properties

    var presenter: PinCodePresentation!

    // MARK: - Private Properties

    private lazy var customView = PinCodeView(frame: UIScreen.main.bounds)
    private var localAuth: LocalAuthentication?

    private func subscribeOnCustomViewActions() {
        customView.didTapAddPhoto = { [unowned self] in
            self.localAuth?.useBiometrics()
        }
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnCustomViewActions()
    }

}

// MARK: - PinCodeViewInterface

extension PinCodeViewController: PinCodeViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
