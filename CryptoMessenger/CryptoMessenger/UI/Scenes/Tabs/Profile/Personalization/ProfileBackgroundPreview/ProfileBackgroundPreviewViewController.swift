import UIKit

// MARK: ProfileBackgroundPreviewViewController

final class ProfileBackgroundPreviewViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfileBackgroundPreviewPresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileBackgroundPreviewView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
        addRightBarButtonItem()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        title = "Просмотр"
    }

    private func addRightBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.profile.settings(),
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = settings
    }

}

// MARK: - ProfileBackgroundPreviewViewInterface

extension ProfileBackgroundPreviewViewController: ProfileBackgroundPreviewViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
