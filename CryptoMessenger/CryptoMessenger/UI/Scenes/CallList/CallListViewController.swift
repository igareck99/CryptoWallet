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
//        showNavigationBar()
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
            action: #selector(backButtonTap)
        )
        navigationItem.leftBarButtonItem = settings
    }

    private func addRightBarButtonItem() {
        let dotes = UIButton(type: .system)
        dotes.setImage(R.image.callList.dotes(), for: .normal)
        dotes.addTarget(self, action: #selector(dotesButtonTap), for: .touchUpInside)
        let phone = UIButton(type: .system)
        phone.setImage(R.image.callList.blackPhone(), for: .normal)
        phone.addTarget(self, action: #selector(newCall), for: .touchUpInside)
        let stackview = UIStackView(arrangedSubviews: [phone, dotes])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 16
        let rightBarButton = UIBarButtonItem(customView: stackview)
        navigationItem.rightBarButtonItems = [rightBarButton]
    }

    // MARK: - Actions

    @objc private func dotesButtonTap() {
        let controller = AdditionalViewController()
        present(controller, animated: true)
        controller.didDeleteTap = { [unowned self] in
            customView.removeAllCalls()
            controller.dismiss(animated: true)
        }
    }

    @objc private func backButtonTap() {
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
