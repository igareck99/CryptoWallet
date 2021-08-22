import UIKit

// MARK: CallListViewController

final class CallListViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: CallListPresentation!

    // MARK: - Private Properties

    private lazy var customView = CallListView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - CallListViewInterface

extension CallListViewController: CallListViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
