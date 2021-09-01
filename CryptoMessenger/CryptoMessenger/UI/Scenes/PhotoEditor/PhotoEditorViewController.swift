import UIKit

// MARK: PhotoEditorViewController

final class PhotoEditorViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: PhotoEditorPresentation!

    // MARK: - Private Properties

    private lazy var customView = PhotoEditorView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.background(.darkBlack())
        addTitleBarButtonItem()
        addLeftBarButtonItem()
        addRightBarButtonItem()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBlackNavigationBar()
        showNavigationBar()
        subscribeOnCustomViewActions()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.photoEditorTitle()
    }

    private func addLeftBarButtonItem() {
        let back = UIBarButtonItem(
            image: R.image.photoEditor.backButton(),
            style: .done,
            target: self,
            action: #selector(backButtonTap)
        )
        navigationItem.leftBarButtonItem = back
    }

    private func addRightBarButtonItem() {
        let dotes = UIBarButtonItem(
            image: R.image.photoEditor.dotes(),
            style: .done,
            target: self,
            action: #selector(dotesButtonTap)
        )
        navigationItem.rightBarButtonItem = dotes
    }

    @objc private func backButtonTap() {
    }

    @objc private func dotesButtonTap() {
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapShare = { [unowned self] in
            let controller = UIActivityViewController(activityItems: [R.image.callList.blackPhone()], applicationActivities: nil)
            present(controller, animated: true, completion: nil)
        }
    }

}

// MARK: - PhotoEditorViewInterface

extension PhotoEditorViewController: PhotoEditorViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
