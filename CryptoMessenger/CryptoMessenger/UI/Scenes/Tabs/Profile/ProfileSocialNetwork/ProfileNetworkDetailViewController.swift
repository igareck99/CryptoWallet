import UIKit

// MARK: - ProfileNetworkDetailViewController

final class ProfileNetworkDetailViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfileNetworkDetailPresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileNetworkDetailView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
        addLeftBarButtonItem()
        addRightBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.profileNetworkDetailTitle()
    }

    private func addLeftBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.callList.back(),
            style: .done,
            target: self,
            action: #selector(backAction)
        )
        navigationItem.leftBarButtonItem = settings
    }

    private func addRightBarButtonItem() {
        let item = UIBarButtonItem(
            title: R.string.localizable.profileDetailRightButton(),
            style: .done,
            target: self,
            action: #selector(backAction)
        )
        item.titleAttributes(
            [
                .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                .font(.bold(15)),
                .color(.blue())
            ],
            for: .normal
        )
        navigationItem.rightBarButtonItem = item
    }

    @objc private func backAction() {
        self.presenter.handleButtonTap()
    }
}

// MARK: - ProfileNetworkDetailViewInterface (ProfileNetworkDetailViewInterface)

extension ProfileNetworkDetailViewController: ProfileNetworkDetailViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
