import UIKit

class SPViewController: BaseViewController {

    // MARK: - Internal Properties

    var didDeleteTap: (() -> Void)?
    var didCancelTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var customview = SPView(frame: UIScreen.main.bounds)
    private lazy var backview = CallListView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnCustomViewActions()
    }

    private func subscribeOnCustomViewActions() {
        customview.didTapDelete = { [unowned self] in
            showAlert()
        }
    }

    // MARK: - Private Methods

    private func showAlert() {
        let alert = UIAlertController(title: R.string.localizable.callListAlertTitle(),
                                      message: R.string.localizable.callListAlertText(),
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.callListAlertActionOne(),
                                      style: UIAlertAction.Style.default, handler: { _ in
                                      }))
        alert.addAction(UIAlertAction(title: R.string.localizable.callListAlertActionTwo(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.backview.removeAllCalls()
                                      }))
        self.present(alert, animated: true, completion: nil)
    }

}
