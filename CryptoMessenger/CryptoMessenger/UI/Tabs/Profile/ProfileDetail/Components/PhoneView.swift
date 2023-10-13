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
                .font(.subheadlineRegular15)
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
