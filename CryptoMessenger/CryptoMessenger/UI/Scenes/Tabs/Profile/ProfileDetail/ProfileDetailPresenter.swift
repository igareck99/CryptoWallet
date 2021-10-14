import Foundation

// MARK: - ProfileDetailPresenter

final class ProfileDetailPresenter {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailSceneDelegate?
    weak var view: ProfileDetailViewInterface?

    // MARK: - Private Properties

    private var state = ProfileDetailFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }
    private var selectedCountry = CountryCodePickerViewController.baseCountry

    // MARK: - Lifecycle

    init(view: ProfileDetailViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: ProfileDetailFlow.ViewState) {
        switch state {
        case .sending:
            break
        case .result:
            guard let country = selectedCountry else { return }
            view?.setCountryCode(country)
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    func backAction() {
        delegate?.handleNextScene(.main)
    }
}

// MARK: - ProfileDetailPresenter (ProfileDetailPresentation)

extension ProfileDetailPresenter: ProfileDetailPresentation {
    func handleButtonTap() {
        backAction()
    }

    func viewDidLoad() {
        guard let country = selectedCountry else { return }
        view?.setCountryCode(country)
    }

    func handleNextScene(_ phone: String) {
        delay(1.4) {
            let prefix = self.selectedCountry?.prefix ?? ""
            print("Some pefix   \(prefix)")
            self.delegate?.handleNextScene(.profileDetail)
        }
    }

    func handleCountryCodeScene() {
        delegate?.handleNextScene(.countryCode(self))
        
    }
}

// MARK: - ProfileDetailPresenter (CountryCodePickerDelegate)

extension ProfileDetailPresenter: CountryCodePickerDelegate {
    func countryCodePickerViewControllerDidPickCountry(
        _ controller: CountryCodePickerViewController, country: CountryCodePickerViewController.Country
    ) {
        state = .result
    }
}
