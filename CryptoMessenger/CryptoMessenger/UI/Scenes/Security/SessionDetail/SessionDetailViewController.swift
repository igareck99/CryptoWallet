import UIKit

// MARK: SessionDetailViewController

final class SessionDetailViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: SessionDetailPresentation!

    // MARK: - Private Properties

    private lazy var customView = SessionDetailView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = AdditionalSessionController()
        present(controller, animated: true)
    }

}

// MARK: - SessionDetailViewInterface

extension SessionDetailViewController: SessionDetailViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
