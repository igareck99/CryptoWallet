import UIKit

// MARK: AppLanguageViewController

final class AppLanguageViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: AppLanguagePresentation!

    // MARK: - Private Properties

    private lazy var customView = AppLanguageView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        title = R.string.localizable.appLanguageTitle()
    }

}

// MARK: - AppLanguageViewInterface

extension AppLanguageViewController: AppLanguageViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
