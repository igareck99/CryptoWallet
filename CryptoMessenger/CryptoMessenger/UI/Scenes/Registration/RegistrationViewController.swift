import UIKit

// MARK: - RegistrationViewController

final class RegistrationViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: RegistrationPresentation!

    // MARK: - Private Properties

    private lazy var customView = RegistrationView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.registrationScreenTitle()
        subscribeOnCustomViewActions()
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customView.subscribeOnKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customView.stopLoading()
        customView.unsubscribeKeyboardNotifications()
    }

    // MARK: - Private Methods

    private func subscribeOnCustomViewActions() {
        customView.didTapNextScene = { [unowned self] phone in
            self.presenter.handleNextScene(phone)
        }
        customView.didTapCountryScene = { [unowned self] in
            self.presenter.handleCountryCodeScene()
        }
    }
}

// MARK: - RegistrationViewInterface

extension RegistrationViewController: RegistrationViewInterface {
    func setCountryCode(_ country: CountryCodePickerViewController.Country) {
        customView.setCountryCode(country)
    }

    func showAlert(title: String?, message: String?) {
        customView.stopLoading()
        presentAlert(title: title, message: message)
    }
}
