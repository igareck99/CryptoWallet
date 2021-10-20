import UIKit

// MARK: PersonalizationViewController

final class PersonalizationViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: PersonalizationPresentation!

    // MARK: - Private Properties

    private lazy var customView = PersonalizationView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
        addRightBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        title = R.string.localizable.personalizationTitle()
    }

    private func addRightBarButtonItem() {
        let button = UIButton()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        button.titleAttributes(
            text: R.string.localizable.profileDetailRightButton(),
            [
                .paragraph(paragraphStyle),
                .font(.bold(15)),
                .color(.blue())
            ]
        )
        let item = UIBarButtonItem(title: R.string.localizable.profileDetailRightButton(),
                                   style: .done,
                                   target: self,
                                   action: #selector(saveAction))
        item.titleAttributes([.paragraph(paragraphStyle),
                              .font(.semibold(15)),
                              .color(.blue())], for: .normal    )
        navigationItem.rightBarButtonItem = item
    }

    @objc private func saveAction() {
    }

}

// MARK: - PersonalizationViewInterface

extension PersonalizationViewController: PersonalizationViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
