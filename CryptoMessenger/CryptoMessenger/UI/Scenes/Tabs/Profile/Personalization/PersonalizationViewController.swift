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
        subscribeOnCustomViewActions()
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

    private func subscribeOnCustomViewActions() {
        customView.didTapLanguage = { [unowned self] in
            let vc = AppLanguageConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        customView.didTapTheme = {
            self.showAlertForTheme()
        }
        customView.didTapTypography = { [unowned self] in
            let vc = TypographyConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        customView.didTapProfileBackground = { [unowned self] in
            let vc = ProfileBackgroundConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc private func saveAction() {
    }

    private func showAlertForTheme() {
        let alert = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)

        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.personalizationSystem(),
                style: .default,
                handler: { _ in
            print("You've pressed system")
        }))

        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.personalizationLight(),
                style: .default,
                handler: { _ in
            print("You've pressed light")
        }))

        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.personalizationDark(),
                style: .default,
                handler: { _ in
            print("You've pressed the dark")
        }))
        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.personalizationCancel(),
                style: .cancel,
                handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - PersonalizationViewInterface

extension PersonalizationViewController: PersonalizationViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
