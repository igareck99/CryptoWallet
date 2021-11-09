import UIKit

// MARK: SecurityViewController

final class SecurityViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: SecurityPresentation!

    // MARK: - Private Properties

    private lazy var customView = SecurityView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.securityTitle()
    }

}

// MARK: - SecurityViewInterface

extension SecurityViewController: SecurityViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
