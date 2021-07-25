import UIKit

// MARK: - GenerationInfoViewController

final class GenerationInfoViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: KeyGenerationPresentation!

    // MARK: - Private Properties

    private lazy var customView = GenerationInfoView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.keyGenerationScreenTitle()
        subscribeOnCustomViewActions()
    }

    // MARK: - Private Methods

    private func subscribeOnCustomViewActions() {
        customView.didTapNewKeyButton = { [unowned self] in

        }
        customView.didTapUseKeyButton = { [unowned self] in

        }
    }
}

// MARK: - KeyGenerationViewInterface

extension GenerationInfoViewController: KeyGenerationViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
