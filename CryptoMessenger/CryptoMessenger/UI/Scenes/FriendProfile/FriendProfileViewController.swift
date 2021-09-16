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

    }

}

// MARK: - FriendProfileViewInterface

extension FriendProfileViewController: FriendProfileViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
