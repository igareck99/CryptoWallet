import Foundation
import SwiftUI

protocol RegistrationResourcable {
    static var typeYourPhone: String { get }
    static var registrationInfo: String { get }
    static var selectCountry: String { get }
    static var yourNumber: String { get }
    static var sendCode: String { get }
    static var plus: String { get }
    static var inavlidCountryCode: String { get }
}

// MARK: - RegistrationResourcable

enum RegistrationResources: RegistrationResourcable {
    static var typeYourPhone: String {
        R.string.localizable.registrationTitle()
    }

    static var registrationInfo: String {
        R.string.localizable.registrationDescription()
    }

    static var selectCountry: String {
        R.string.localizable.registrationSelectCountry()
    }

    static var yourNumber: String {
        R.string.localizable.registrationYourNumber()
    }

    static var sendCode: String {
        R.string.localizable.registrationSendCode()
    }

    static var plus: String {
        "+"
    }
    
    static var inavlidCountryCode: String {
        R.string.localizable.registrationInvalidCountryCode()
    }
}
