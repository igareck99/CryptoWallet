import UIKit

// MARK: - KeyImportViewController

final class KeyImportViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: KeyImportPresentation!

    // MARK: - Private Properties

    private lazy var customView = KeyImportView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.keyImportScreenTitle()
        subscribeOnCustomViewActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customView.subscribeOnKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customView.unsubscribeKeyboardNotifications()
        customView.stopLoading()
    }

    // MARK: - Private Methods

    private func subscribeOnCustomViewActions() {
        customView.didTapImportButton = { [unowned self] in
            self.presenter.handleImportButtonTap()
        }
    }
}

// MARK: - KeyImportViewInterface

extension KeyImportViewController: KeyImportViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
