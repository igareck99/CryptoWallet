import UIKit

// MARK: SessionViewController

final class SessionViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: SessionPresentation!

    // MARK: - Private Properties

    private lazy var customView = SessionView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnCustomViewActions()
        addTitleBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.sessionTitle()
    }

    private func subscribeOnCustomViewActions() {
        customView.didTap = { [unowned self] in
            let vc = ProfileConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            let controller = AdditionalSessionController()
            sessionInfo[0].text = sessionList[selectedCell].place
            sessionInfo[1].text = sessionList[selectedCell].time
            switch sessionList[selectedCell].device {
            case .iphone:
                loginDevice = "IPhone"
            case .android:
                loginDevice = "Android"
            }
            sessionInfo[2].text = sessionList[selectedCell].loginMethod
            controller.didPopScreen = {
                self.navigationController?.popViewController(animated: true)
                controller.dismiss(animated: true, completion: nil)
            }
            present(controller, animated: true)
        }
    }

}

// MARK: - SessionViewInterface

extension SessionViewController: SessionViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
