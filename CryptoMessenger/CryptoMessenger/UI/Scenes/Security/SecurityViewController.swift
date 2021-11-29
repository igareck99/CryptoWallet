import UIKit
import LocalAuthentication

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
        subscribeOnCustomViewActions()
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

    private func subscribeOnCustomViewActions() {
        customView.didProfileViewingTap = { [unowned self] in
            createActionSheet()
        }
        customView.didCreateFalsePasswordTap = { [unowned self] in
            let vc = SecurityPinCodeConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        customView.didPinCodeTap = { [unowned self] in
            let vc = SecurityPinCodeConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func createActionSheet() {
        let alert = UIAlertController(title: nil, message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(
            title: R.string.localizable.profileViewingAll(),
            style: .default,
            handler: { _ in
                self.customView.setVisibleProfile(state: R.string.localizable.profileViewingAll())
        })
        )

        alert.addAction(UIAlertAction(
            title: R.string.localizable.profileViewingContacts(),
            style: .default,
            handler: { _ in
                self.customView.setVisibleProfile(state: R.string.localizable.profileViewingContacts())
        })
        )

        alert.addAction(UIAlertAction(
            title: R.string.localizable.profileViewingNobody(),
            style: .default,
            handler: { _ in
                self.customView.setVisibleProfile(state:  R.string.localizable.profileViewingNobody())
        })
        )

        alert.addAction(UIAlertAction(title: R.string.localizable.photoEditorAlertCancel(),
                                      style: .cancel))

        present(alert, animated: true)
    }

}

// MARK: - SecurityViewInterface

extension SecurityViewController: SecurityViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
