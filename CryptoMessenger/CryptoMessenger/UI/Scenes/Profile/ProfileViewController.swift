import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfilePresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        addRightBarButtonItem()
    }

    private func addLeftBarButtonItem() {
        let title = UIBarButtonItem(title: "@ikea_rus", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = title
    }

    private func addRightBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.profile.settings(),
            style: .done,
            target: self,
            action: #selector(rightButtonTap)
        )
        navigationItem.rightBarButtonItem = settings
    }

    // MARK: - Actions

    @objc private func rightButtonTap() {

    }
}

// MARK: - ProfileViewInterface

extension ProfileViewController: ProfileViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
