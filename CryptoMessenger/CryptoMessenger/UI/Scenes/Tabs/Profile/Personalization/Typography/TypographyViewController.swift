import UIKit

// MARK: TypographyViewController

final class TypographyViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: TypographyPresentation!

    // MARK: - Private Properties

    private lazy var customView = TypographyView(frame: UIScreen.main.bounds)

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
        title = R.string.localizable.typographyTitle()
    }

}

// MARK: - TypographyViewInterface

extension TypographyViewController: TypographyViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
