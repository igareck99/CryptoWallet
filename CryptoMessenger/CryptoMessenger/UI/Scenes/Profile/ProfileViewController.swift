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
        title = "My profile"
    }
    
}

// MARK: - ProfileViewInterface

extension ProfileViewController: ProfileViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
