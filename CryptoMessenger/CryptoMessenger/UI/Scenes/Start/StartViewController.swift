import UIKit

// MARK: StartViewController

final class StartViewController: BaseViewController {

    // MARK: - Public Properties

    var presenter: StartPresentation!

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Private Properties

    private lazy var customView = StartView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
}

// MARK: - StartViewController (StartViewInterface)

extension StartViewController: StartViewInterface {
    func startActivity(animated: Bool) {
        customView.showActivity(backgroundColor: .white, tintColor: .lightGray, animated: true)
    }

    func stopActivity(animated: Bool) {
        customView.hideActivity(animated: animated)
    }
}
