import SwiftUI

enum AuthContentLink: Identifiable, Hashable {

    case registration(delegate: RegistrationSceneDelegate?)
    case verification(delegate: VerificationSceneDelegate?)

    // MARK: - Identifiable

    var id: String {
        String(describing: self)
    }

    // MARK: - Equatable

    static func == (lhs: AuthContentLink, rhs: AuthContentLink) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum AuthSheetLink: Identifiable, Hashable {
    
    case countryCodeScene(delegate: CountryCodePickerDelegate)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: AuthSheetLink, rhs: AuthSheetLink) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
