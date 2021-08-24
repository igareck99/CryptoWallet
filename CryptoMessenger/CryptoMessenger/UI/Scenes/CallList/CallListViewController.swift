import UIKit

// MARK: - CallListViewController

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
        addTitleBarButtonItem()
        addLeftBarButtonItem()
        addRightBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.callListTitle()
    }

    private func addLeftBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.callList.back(),
            style: .done,
            target: self,
            action: #selector(leftButtonTap)
        )
        navigationItem.leftBarButtonItem = settings
    }

    private func addRightBarButtonItem() {
        let dotes = UIBarButtonItem(
            image: R.image.callList.dotes(),
            style: .done,
            target: self,
            action: #selector(rightButtonTap)
        )
        let phone = UIBarButtonItem(
            image: R.image.callList.bluePhone(),
            style: .done,
            target: self,
            action: #selector(newCall)

        )
        navigationItem.rightBarButtonItems = [phone, dotes]
    }

    // MARK: - Actions

    @objc private func rightButtonTap() {

    }

    @objc private func leftButtonTap() {

    }

    @objc private func newCall() {

    }

}

// MARK: - CallListViewInterface

extension CallListViewController: CallListViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
