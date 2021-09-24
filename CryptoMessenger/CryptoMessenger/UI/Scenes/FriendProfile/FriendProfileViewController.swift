import UIKit

// MARK: FriendProfileViewController

final class FriendProfileViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: FriendProfilePresentation!

    // MARK: - Private Properties

    private lazy var customView = FriendProfileView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
        addLeftBarButtonItem()
        addRightBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = profile1.nickname
    }

    private func addLeftBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.callList.back(),
            style: .done,
            target: self,
            action: #selector(backButtonTap)
        )
        navigationItem.leftBarButtonItem = settings
    }

    private func addRightBarButtonItem() {
        let dotes = UIBarButtonItem(
            image: R.image.callList.dotes(),
            style: .done,
            target: self,
            action: #selector(dotesButtonTap)
        )
        navigationItem.rightBarButtonItem = dotes
    }

    @objc private func backButtonTap() {
        let controller = ProfileViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func dotesButtonTap() {
        let controller = MenuFriendViewController()
        present(controller, animated: true)
    }

}

// MARK: - FriendProfileViewInterface

extension FriendProfileViewController: FriendProfileViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
