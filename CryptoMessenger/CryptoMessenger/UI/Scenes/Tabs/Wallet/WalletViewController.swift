import UIKit

// MARK: - WalletViewController

final class WalletViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: WalletPresentation!

    // MARK: - Private Properties

    private lazy var customView = WalletView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        addRightBarButtonItem()
    }

    private func addLeftBarButtonItem() {
        let title = UIBarButtonItem(title: "Кошелек", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = title
    }

    private func addRightBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.wallet.settings(),
            style: .done,
            target: self,
            action: #selector(rightButtonTap)
        )
        navigationItem.rightBarButtonItem = settings
    }

    // MARK: - Actions

    @objc private func rightButtonTap() {

    }
}

// MARK: - WalletViewInterface

extension WalletViewController: WalletViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
