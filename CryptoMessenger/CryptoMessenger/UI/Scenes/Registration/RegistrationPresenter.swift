import Foundation

// MARK: - RegistrationPresenter

final class RegistrationPresenter {

    // MARK: - Internal Properties

    weak var delegate: RegistrationSceneDelegate?
    weak var view: RegistrationViewInterface?

    // MARK: - Private Properties

    @Injectable private var apiClient: APIClientManager
    @Injectable private var userCredentials: UserCredentialsStorageService

    private var selectedCountry = CountryCodePickerViewController.baseCountry
    private var state = RegistrationFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: RegistrationViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: RegistrationFlow.ViewState) {
        switch state {
        case .sending:
            break
        case let .result(country):
            view?.setCountryCode(country)
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    private func sendPhone(_ phone: String) {
        let prefix = selectedCountry?.prefix ?? ""
        let numbers = prefix.numbers + phone.numbers
        apiClient.request(Endpoints.Registration.get(numbers)) { [weak self] _ in
            self?.userCredentials.userPhoneNumber = prefix + " " + phone
            self?.delegate?.handleNextScene(.verification)
        } failure: { [weak self] error in
            self?.state = .error(message: error.localizedDescription)
        }
    }
}

// MARK: - RegistrationPresenter (RegistrationPresentation)

extension RegistrationPresenter: RegistrationPresentation {
    func viewDidLoad() {
        guard let country = selectedCountry else { return }
        view?.setCountryCode(country)
    }

    func handleNextScene(_ phone: String) {
        delay(1.4) {
            self.delegate?.handleNextScene(.verification)
        }
        //sendPhone(phone)
    }

    func handleCountryCodeScene() {
        delegate?.handleNextScene(.countryCode(self))
    }
}

// MARK: - RegistrationPresenter (CountryCodePickerDelegate)

extension RegistrationPresenter: CountryCodePickerDelegate {
    func countryCodePickerViewControllerDidPickCountry(
        _ controller: CountryCodePickerViewController, country: CountryCodePickerViewController.Country
    ) {
        state = .result(country)
    }
}
