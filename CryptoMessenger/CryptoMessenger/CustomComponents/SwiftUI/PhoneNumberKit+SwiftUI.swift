import PhoneNumberKit
import SwiftUI
import UIKit

// MARK: - CountryCoderTextFieldView

struct CountryCoderTextFieldView: UIViewRepresentable {

    // MARK: - Internal Properties

    @Binding var phoneNumber: String

    // MARK: - Internal Methods

    func makeUIView(context: Context) -> PhoneNumberTextField {
        let textField = PhoneNumberTextField()
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.maxDigits = 0
        textField.withDefaultPickerUI = true
        return textField
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {}
}

// MARK: - PhoneNumberTextFieldView

struct PhoneNumberTextFieldView: UIViewRepresentable {

    // MARK: - Internal Properties

    @Binding var phoneNumber: String

    // MARK: - Internal Methods

    func makeUIView(context: Context) -> PhoneNumberTextField {
        let textField = PhoneNumberTextField()
        textField.placeholder = R.string.localizable.profileDetailPhonePlaceholder()
        textField.withFlag = false
        textField.withPrefix = false
        textField.maxDigits = 10
        textField.withDefaultPickerUI = true
        return textField
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {}
}
