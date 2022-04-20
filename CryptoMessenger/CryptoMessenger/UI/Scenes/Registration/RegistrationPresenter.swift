import Combine
import Foundation

// MARK: - RegistrationPresenter

final class RegistrationPresenter {

    // MARK: - Internal Properties

    weak var delegate: RegistrationSceneDelegate?
    weak var view: RegistrationViewInterface?

    // MARK: - Private Properties

    @Injectable private var apiClient: APIClientManager
	private let userCredentials: UserCredentialsStorage

    private var selectedCountry = CountryCodePickerViewController.baseCountry
    private var state = RegistrationFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
		view: RegistrationViewInterface,
		userCredentials: UserCredentialsStorage
	) {
        self.view = view
		self.userCredentials = userCredentials
    }

    // MARK: - Private Methods

    private func updateView(_ state: RegistrationFlow.ViewState) {
        switch state {
        case .sending:
            ()
        case let .result(country):
            selectedCountry = country
            view?.setCountryCode(country)
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    private func sendPhone(_ phone: String) {
        let prefix = selectedCountry?.prefix ?? ""
        let numbers = prefix.numbers + phone.numbers

        apiClient
            .publisher(Endpoints.Registration.sms(numbers))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    guard let err = error as? APIError else {
                        self?.state = .error(message: APIError.serverError.localizedDescription)
                        return
                    }
                    self?.state = .error(message: err.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.userCredentials.userPhoneNumber = prefix + " " + phone
                self?.delegate?.handleNextScene(.verification)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - RegistrationPresenter (RegistrationPresentation)

extension RegistrationPresenter: RegistrationPresentation {
    func viewDidLoad() {
        guard let country = selectedCountry else { return }
        view?.setCountryCode(country)
    }

    func handleNextScene(_ phone: String) {
        sendPhone(phone)
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
