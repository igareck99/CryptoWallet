import UIKit

// MARK: - AboutAppViewController

final class AboutAppViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: AboutAppPresentation!

    // MARK: - Private Properties

    private lazy var customView = AboutAppView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeCustomViewActions()
        addTitleBarButtonItem()
        // addLeftBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addLeftBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.callList.back(),
            style: .done,
            target: self,
            action: #selector(backButtonTap)
        )
        navigationItem.leftBarButtonItem = settings
    }

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.aboutAppTitle()
    }

    @objc private func backButtonTap() {}

    private func subscribeCustomViewActions() {
        customView.didTapLicense = { [unowned self] in
            let vc = CustomWebViewController(url: AppConstants.licensePage.aboutApp)
            present(vc, animated: true)
        }
        customView.didTapPolitics = { [unowned self] in
            let vc = CustomWebViewController(url: AppConstants.rulesPage.aboutApp)
            present(vc, animated: true)
        }
    }
}

// MARK: - AboutAppViewInterface

extension AboutAppViewController: AboutAppViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
