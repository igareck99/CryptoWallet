import UIKit

// MARK: BlackListViewController

final class BlackListViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: BlackListPresentation!

    // MARK: - Private Properties

    private lazy var customView = BlackListView(frame: UIScreen.main.bounds)

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
        navigationItem.title = R.string.localizable.blackListTitle()
    }

    private func showDeleteAlert() {
        let alert = UIAlertController(title:
                                        R.string.localizable.blackListAlertTitle() + blockedPeople[selectedCellToBlock].name,
                                      message: " ",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:
                                      R.string.localizable.personalizationCancel(),
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in        } ))
        alert.addAction(UIAlertAction(title: R.string.localizable.pinCodeAlertYes(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.customView.unblockUser(index: selectedCellToBlock)
                                      }))
        self.present(alert, animated: true, completion: nil)
    }

    private func subscribeOnCustomViewActions() {
        customView.didUserTap = { [unowned self] in
            showDeleteAlert()
        }
    }
}

// MARK: - BlackListViewInterface

extension BlackListViewController: BlackListViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
