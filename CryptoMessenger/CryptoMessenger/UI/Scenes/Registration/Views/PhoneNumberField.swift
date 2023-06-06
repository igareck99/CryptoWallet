import Combine
import PhoneNumberKit
import SwiftUI
import UIKit

struct PhoneNumberField: UIViewRepresentable {

    @Binding var phoneNumber: String
    @Binding var isPhoneNumberValid: Bool
    let onCountryPhoneUpdate: PassthroughSubject<String, Never>
    let placeholder: String
    private let textField = PhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.backgroundColor = .clear
        // TODO: Создать Bind для этого цвета
        textField.textColor = .chineseBlack
        textField.withExamplePlaceholder = false
        textField.withFlag = false
        textField.withPrefix = false
        textField.placeholder = placeholder
        textField.becomeFirstResponder()
        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
        return textField
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        var control: PhoneNumberField
        private var cancellable = Set<AnyCancellable>()

        init(_ control: PhoneNumberField) {
            self.control = control
            super.init()
            self.control.onCountryPhoneUpdate.sink { [weak self] in
                self?.control.textField.partialFormatter.defaultRegion = $0
            }
            .store(in: &cancellable)
        }

        @objc func onTextUpdate(textField: UITextField) {
            self.control.phoneNumber = textField.text ?? ""
            self.control.isPhoneNumberValid = control.textField.isValidNumber
        }
    }
}
