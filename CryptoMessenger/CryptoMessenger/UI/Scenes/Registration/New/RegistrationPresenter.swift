import Combine
import Foundation
import SwiftUI

// swiftlint:disable all

protocol RegistrationPresenterProtocol: ObservableObject {
    
    associatedtype Colors: RegistrationColorable
    
    var colors: Colors { get }
    
    var errorTextOpacity: Binding<Double> { get }
    var buttonLoaderOpacity: Binding<Double> { get }
    var buttonTextOpacity: Binding<Double> { get }
    var onCountryPhoneUpdate: PassthroughSubject<String, Never> { get }
    var sendButtonEnabled: Binding<Bool> { get set }
    var isPhoneNumberValid: Binding<Bool> { get set }
    var phone: Binding<String> { get set }
    var selectedCountry: Binding<String> { get set }
    var countryCode: Binding<String> { get set }
    var sources: RegistrationResourcable.Type { get }
    func didTapSelectCountry()
    func didTapNextButton()
}

final class RegistrationPresenter<Colors: RegistrationColorable> {
    var isNextEnabled: Bool {
        !self.phone.wrappedValue.isEmpty &&
        !self.countryCode.wrappedValue.isEmpty &&
        self.isPhoneNumberValid.wrappedValue
    }
    
    var isCountrySelected: Bool {
        !self.countryCode.wrappedValue.isEmpty &&
        !self.selectedCountry.wrappedValue.isEmpty &&
        self.country != nil
    }
    
    @Published var isPhoneValid = false
    lazy var isPhoneNumberValid: Binding<Bool> = .init(
        get: { self.isPhoneValid },
        set: { self.isPhoneValid = $0
            self.updateColors()
        }
    )
    
    @Published var phoneNumber = ""
    lazy var phone: Binding<String> = .init(
        get: { self.phoneNumber },
        set: { self.phoneNumber = $0
            self.updateColors()
            self.updateSelectCountry()
        }
    )
    
    @Published var phoneCode = "+"
    lazy var countryCode: Binding<String> = .init(
        get: { self.phoneCode },
        set: { self.phoneCode = $0
            self.updateColors()
        }
    )
    
    @Published var countryText: String
    lazy var selectedCountry: Binding<String> = .init(
        get: { self.countryText },
        set: { self.countryText = $0 }
    )
    
    var sbEnabled: Bool = false
    lazy var sendButtonEnabled: Binding<Bool> = .init(
        get: { self.sbEnabled },
        set: { self.sbEnabled = $0 }
    )
    
    @Published var bLoaderOpacity: Double = .zero
    lazy var buttonLoaderOpacity: Binding<Double> = .init(
        get: { self.bLoaderOpacity },
        set: { self.bLoaderOpacity = $0
            self.objectWillChange.send()
        }
    )
    
    @Published var bTextOpacity: Double = 1
    lazy var buttonTextOpacity: Binding<Double> = .init(
        get: { self.bTextOpacity },
        set: { self.bTextOpacity = $0
            self.objectWillChange.send()
        }
    )
    
    @Published var eTextOpacity: Double = .zero
    lazy var errorTextOpacity: Binding<Double> = .init(
        get: { self.eTextOpacity },
        set: { self.eTextOpacity = $0
            self.objectWillChange.send()
        }
    )
    
    let onCountryPhoneUpdate = PassthroughSubject<String, Never>()
    let sources: RegistrationResourcable.Type
    weak var delegate: RegistrationSceneDelegate?

    // MARK: - Private Properties

    @Injectable private var apiClient: APIClientManager
	private let userCredentials: UserCredentialsStorage
	private let keychainService: KeychainServiceProtocol
    private var country: CountryCodePickerViewController.Country?
    let colors: Colors
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
		userCredentials: UserCredentialsStorage,
		keychainService: KeychainServiceProtocol,
        colors: Colors,
        sources: RegistrationResourcable.Type = RegistrationResources.self
	) {
		self.userCredentials = userCredentials
		self.keychainService = keychainService
        self.colors = colors
        self.sources = sources
        self.countryText = sources.selectCountry
        self.updateColors()
    }

    // MARK: - Private Methods
    
    private func updateColors() {
        self.colors.sendButtonColor = !self.isNextEnabled ? .constant(.ghostWhite) : .constant(.dodgerBlue)
        self.colors.buttonTextColor = !self.isNextEnabled ? .constant(.ashGray) : .constant(.white)
        self.sendButtonEnabled = .constant(self.isNextEnabled)
        self.objectWillChange.send()
    }
    
    private func updateSelectCountry() {
        self.colors.selectCountryStrokeColor = self.isCountrySelected ? .constant(.clear) : .constant(.spanishCrimson)
        self.errorTextOpacity = self.isCountrySelected ? .constant(.zero) : .constant(1)
        self.colors.selectCountryErrorColor = self.isCountrySelected ? .constant(.clear) : .constant(.spanishCrimson)
        self.objectWillChange.send()
    }

    private func sendPhone(_ phone: String) {
        let prefix = country?.prefix ?? ""
        let numbers = prefix.numbers + phone.numbers

        buttonLoaderOpacity = .constant(1)
        buttonTextOpacity = .constant(0)
        apiClient.publisher(Endpoints.Registration.sms(numbers))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.buttonLoaderOpacity = .constant(0)
                self?.buttonTextOpacity = .constant(1)
                switch completion {
                    case .failure(let error):
                        guard let err = error as? APIError else {
                            // TODO: Обработать этот кейс
                            // self?.state = .error(message: APIError.serverError.localizedDescription)
                            return
                        }
                        debugPrint("\(err)")
                        // TODO: Обработать этот кейс
                        // self?.state = .error(message: err.localizedDescription)
                    default:
                        break
                }
            } receiveValue: { [weak self] _ in
                self?.keychainService.apiUserPhoneNumber = prefix + " " + phone
                self?.delegate?.handleNextScene(.verification)
            }
            .store(in: &subscriptions)
    }
    
    func updateCountry(selectedCountry: CountryCodePickerViewController.Country) {
        self.country = selectedCountry
        self.countryCode = .constant(selectedCountry.prefix)
        self.selectedCountry = .constant(selectedCountry.name)
        self.updateColors()
        self.updateSelectCountry()
    }
}

// MARK: - RegistrationPresenterProtocol

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func didTapSelectCountry() {
        delegate?.handleNextScene(.countryCode(self))
    }
    
    func didTapNextButton() {
        sendPhone(phoneNumber)
    }
}

// MARK: - CountryCodePickerDelegate

extension RegistrationPresenter: CountryCodePickerDelegate {
    func countryCodePickerViewControllerDidPickCountry(
        _ controller: CountryCodePickerViewController,
        country: CountryCodePickerViewController.Country
    ) {
        updateCountry(selectedCountry: country)
        onCountryPhoneUpdate.send(country.code)
    }
}
