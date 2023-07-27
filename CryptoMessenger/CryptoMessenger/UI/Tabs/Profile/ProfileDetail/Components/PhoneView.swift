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
                .foreground(.black())
                .font(.regular(15))
                .background(.paleBlue())
                .frame(height: 44)
                .padding([.leading, .trailing], 16)
        }
        .frame(height: 44)
        .background(.paleBlue())
        .cornerRadius(8)
        .onAppear {
            phoneField = PhoneNumberTextFieldView(phoneNumber: $phone)
        }
    }
}
