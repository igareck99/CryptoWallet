import Foundation

// MARK: - RegistrationFlow

enum RegistrationFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result(CountryCodePickerViewController.Country)
        case error(message: String)
    }
}
