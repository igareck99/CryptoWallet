import SwiftUI
import Combine
import PhoneNumberKit

// MARK: - CreateContactViewModel

final class CreateContactViewModel: ObservableObject {

    // MARK: - Internal Properties

    var coordinator: ChatCreateFlowCoordinatorProtocol?
    let resources: CreateContactResourcable.Type
    @Published var selectedCountry = ""
    @Published var countryCode = ""
    @Published var phone = ""
    @Published var isPhoneNumberValid = false
    @Published var nameSurnameText = ""
    @Published var numberText = ""
    @Published var isContryCodePicker = false
    @Published var selectedImage: UIImage?
    let onCountryPhoneUpdate = PassthroughSubject<String, Never>()
    private var country: CountryCodePickerViewController.Country?
    let colors = RegistrationColors()
    @Injectable private var contactsStore: ContactsManager
    
    init(
        resources: CreateContactResourcable.Type = CreateContactResources.self
    ) {
        self.resources = resources
        initCountry()
    }
    
    func didTapSelectCountry() {
        isContryCodePicker = true
    }
    
    func popToRoot() {
        coordinator?.toParentCoordinator()
    }

    func updateCountry(selectedCountry: CountryCodePickerViewController.Country) {
        self.country = selectedCountry
        self.countryCode = selectedCountry.prefix
        self.selectedCountry = selectedCountry.name
    }
    
    func createContact() {
        let phone = (countryCode + phone).replaceCharacters(characters: "()- ", toSeparator: " ")
        contactsStore.createContact(selectedImage: selectedImage,
                                              nameSurnameText: nameSurnameText,
                                              numberText: phone)
    }
    
    private func initCountry() {
        self.selectedCountry = "Выберите страну"
    }
}

// MARK: - CountryCodePickerDelegate

extension CreateContactViewModel: CountryCodePickerDelegate {
    func countryCodePickerViewControllerDidPickCountry(
        _ controller: CountryCodePickerViewController,
        country: CountryCodePickerViewController.Country
    ) {
        updateCountry(selectedCountry: country)
    }
}
    

    
    
