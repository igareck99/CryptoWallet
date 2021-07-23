import UIKit

// MARK: - VerificationViewController

final class VerificationViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: VerificationPresentation!

    // MARK: - Private Properties

    private lazy var customView = VerificationView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.verificationScreenTitle()
        subscribeOnCustomViewActions()
        presenter.viewDidLoad()
    }

    // MARK: - Private Methods

    private func subscribeOnCustomViewActions() {
        customView.didTapNextScene = { [unowned self] _ in
            //self.presenter.handleNextScene(phone)
        }
    }
}

// MARK: - VerificationViewInterface

extension VerificationViewController: VerificationViewInterface {
    func setPhoneNumber(_ phone: String) {
        customView.setPhoneNumber(phone)
    }

    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
