import SwiftUI
import Combine

// MARK: - InputPhoneCreateContactView

struct InputPhoneCreateContactView<Colors: RegistrationColorable>: View {
    let phonePlaceholder: String
    var phone: Binding<String>
    var isPhoneNumberValid: Binding<Bool>
    var keyboardFocused: FocusState<Bool>.Binding
    let onCountryPhoneUpdate: PassthroughSubject<String, Never>
    @StateObject var colors: Colors

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 0) {
                PhoneNumberField(
                    phoneNumber: phone,
                    isPhoneNumberValid: isPhoneNumberValid,
                    onCountryPhoneUpdate: onCountryPhoneUpdate,
                    placeholder: phonePlaceholder
                )
                .autocorrectionDisabled(true)
                .keyboardType(.phonePad)
                .padding(.horizontal, 16)
                .focused(keyboardFocused)
            }
            .frame(height: 46)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(colors.phoneBackColor.wrappedValue)
            )
        }
        .frame(height: 46)
    }
}
