import UIKit
import SPStorkController

// MARK: - CallListViewController

final class CallListViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: CallListPresentation!

    // MARK: - Private Properties

    private lazy var customView = CallListView(frame: UIScreen.main.bounds)
    private lazy var brushButton = UIButton()

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
        let dotes = UIButton(type: .system)
        dotes.setImage(R.image.callList.dotes(), for: .normal)
        dotes.addTarget(self, action: #selector(rightButtonTap), for: .touchUpInside)
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

    @objc private func rightButtonTap() {
        print("rightButtonTap")
        let controller = SPViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.view.background(.white())
        transitionDelegate.customHeight = 114
        transitionDelegate.indicatorMode = .alwaysLine
        self.present(controller, animated: true, completion: nil)
    }

    @objc private func leftButtonTap() {
        print("leftButtonTap")
    }

    @objc private func newCall() {
        print("newCall")
    }

}

// MARK: - CallListViewInterface

extension CallListViewController: CallListViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
