import SwiftUI
import UIKit
import PhoneNumberKit

struct CountryCoderTextFieldView: UIViewRepresentable {
    @Binding var phoneNumber: String
    private let textField = PhoneNumberTextField()
    
    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.maxDigits = 0
        textField.withDefaultPickerUI = true
        return textField
    }

    func getCurrentText() {
        self.phoneNumber = textField.text!
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
    }

}

struct PhoneNumberTextFieldView: UIViewRepresentable {
    @Binding var phoneNumber: String
    private let textField = PhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.placeholder = R.string.localizable.profileDetailPhonePlaceholder()
        textField.withFlag = false
        textField.withPrefix = false
        textField.maxDigits = 10
        textField.withDefaultPickerUI = true
        return textField
    }

    func getCurrentText() {
        self.phoneNumber = textField.text!
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
    }

}
