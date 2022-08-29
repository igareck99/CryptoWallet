import SwiftUI
import PhoneNumberKit

// MARK: - CountryCodeView

struct CountryCodeView: View {

    // MARK: - Internal Properties

    @Binding var countryCode: String
    let phoneNumberKit = PhoneNumberKit()

    // MARK: - Private Properties

    @State private var countryField: CountryCoderTextFieldView?

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading,
               spacing: 8) {
            Text(R.string.localizable.profileDetailPhonePlaceholder())
                .padding(.leading, 16)
                .font(.bold(15))
                .foreground(.darkGray())
            HStack {
                countryField
                    .frame(height: 44)
                R.image.additionalMenu.grayArrow.image
                    .padding(.trailing, 34)
            }.background(.lightBlue())
                .padding([.leading, .trailing], 16)
                .cornerRadius(8)
        }.onAppear {
            countryField = CountryCoderTextFieldView(phoneNumber: $countryCode)
        }
    }
}

