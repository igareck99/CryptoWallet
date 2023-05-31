import Combine
import SwiftUI

struct InputPhoneView<Colors: RegistrationColorable>: View {
    let phonePlaceholder: String
    var countryCode: Binding<String>
    var phone: Binding<String>
    var isPhoneNumberValid: Binding<Bool>
    var keyboardFoucsed: FocusState<Bool>.Binding
    let onCountryPhoneUpdate: PassthroughSubject<String, Never>
    @StateObject var colors: Colors

    var body: some View {
        HStack(spacing: 8) {
            Text(countryCode.wrappedValue)
                .multilineTextAlignment(.center)
                .font(.system(size: 17))
                .foregroundColor(colors.phoneSignColor.wrappedValue)
                .frame(width: 64, height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(colors.selectCountryStrokeColor.wrappedValue, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(colors.phoneBackColor.wrappedValue)
                        )
                )

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
                .focused(keyboardFoucsed)
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
