import SwiftUI
import PhoneNumberKit

// MARK: - PhoneView

struct PhoneView: View {

    // MARK: - Internal Properties

    @Binding var phone: String
    @State private var phoneField: PhoneNumberTextFieldView?
    let phoneNumberKit = PhoneNumberKit()

    // MARK: - Body

    var body: some View {
        HStack {
            phoneField
                .foregroundColor(.chineseBlack)
                .font(.system(size: 15, weight: .regular))
                .background(Color.aliceBlue)
                .frame(height: 44)
                .padding([.leading, .trailing], 16)
        }
        .frame(height: 44)
        .background(Color.aliceBlue)
        .cornerRadius(8)
        .onAppear {
            phoneField = PhoneNumberTextFieldView(phoneNumber: $phone)
        }
    }
}
