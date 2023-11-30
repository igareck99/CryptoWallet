import Combine
import Foundation
import SwiftUI

// swiftlint:disable all

protocol RegistrationSceneDelegate: AnyObject {
//    func handleNextScene(_ scene: AuthCoordinator.Scene)
    
    func onFinishInputPhone()
    
    func onTapCountryCodeSelect(delegate: CountryCodePickerDelegate)
}

protocol RegistrationPresenterProtocol: ObservableObject {
    
    associatedtype Colors: RegistrationColorable
    var colors: Colors { get }
    
    var isSnackbarPresented: Bool { get set}
    var messageText: String { get set }
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
    
    var isPhoneValid = false
    lazy var isPhoneNumberValid: Binding<Bool> = .init(
        get: { self.isPhoneValid },
        set: { self.isPhoneValid = $0
            self.updateColors()
        }
    )
    
    var phoneNumber = ""
    lazy var phone: Binding<String> = .init(
        get: { self.phoneNumber },
        set: { self.phoneNumber = $0
            self.updateColors()
            self.updateSelectCountry()
        }
    )
    
    var phoneCode = "+"
    lazy var countryCode: Binding<String> = .init(
        get: { self.phoneCode },
        set: { self.phoneCode = $0
            self.updateColors()
        }
    )
    
    lazy var selectedCountry: Binding<String> = .constant(sources.selectCountry)
    var sendButtonEnabled: Binding<Bool> = .constant(false)
    var errorTextOpacity: Binding<Double> = .constant(.zero)
    var buttonLoaderOpacity: Binding<Double> = .constant(.zero)
    var buttonTextOpacity: Binding<Double> = .constant(1)
    
    let onCountryPhoneUpdate = PassthroughSubject<String, Never>()
    let sources: RegistrationResourcable.Type
    let colors: Colors
    var isSnackbarPresented = false
    var messageText: String = ""
    weak var delegate: RegistrationSceneDelegate?
    private var apiClient: APIClientManager
    private let userCredentials: UserCredentialsStorage
    private let keychainService: KeychainServiceProtocol
    private var country: CountryCodePickerViewController.Country?
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        apiClient: APIClientManager,
        userCredentials: UserCredentialsStorage,
        keychainService: KeychainServiceProtocol,
        colors: Colors,
        sources: RegistrationResourcable.Type = RegistrationResources.self
    ) {
        self.apiClient = apiClient
        self.userCredentials = userCredentials
        self.keychainService = keychainService
        self.colors = colors
        self.sources = sources
        self.updateColors()
    }
}

private extension RegistrationPresenter {
    
    func updateColors() {
        self.colors.sendButtonColor = !self.isNextEnabled ? .constant(.ghostWhite) : .constant(.dodgerBlue)
        self.colors.buttonTextColor = !self.isNextEnabled ? .constant(.ashGray) : .constant(.white)
        self.sendButtonEnabled = .constant(self.isNextEnabled)
        self.objectWillChange.send()
    }
    
    func updateSelectCountry() {
        self.colors.selectCountryStrokeColor = self.isCountrySelected ? .constant(.clear) : .constant(.spanishCrimson)
        self.errorTextOpacity = self.isCountrySelected ? .constant(.zero) : .constant(1)
        self.colors.selectCountryErrorColor = self.isCountrySelected ? .constant(.clear) : .constant(.spanishCrimson)
        self.objectWillChange.send()
    }
    
    func updateOpacity(_ opacity: Double) {
        buttonLoaderOpacity = .constant(opacity)
        buttonTextOpacity = .constant(1 - opacity)
        self.objectWillChange.send()
    }

    func sendPhone(_ phone: String) {
        let prefix = country?.prefix ?? ""
        let numbers = prefix.numbers + phone.numbers
        updateOpacity(1)
        apiClient.publisher(Endpoints.Registration.sms(numbers))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.updateOpacity(0)
                switch completion {
                    case .failure(let error):
                        guard let err = error as? APIError else {
                            self?.showSnackBar(text: "Ошибка API")
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
                self?.delegate?.onFinishInputPhone()
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
    
    func showSnackBar(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageText = text
            self?.isSnackbarPresented = true
            self?.objectWillChange.send()
        }

        delay(3) { [weak self] in
            self?.messageText = ""
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }
}

// MARK: - RegistrationPresenterProtocol

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func didTapSelectCountry() {
        delegate?.onTapCountryCodeSelect(delegate: self)
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
