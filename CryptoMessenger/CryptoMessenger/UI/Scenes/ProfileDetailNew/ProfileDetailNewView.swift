import SwiftUI
import PhoneNumberKit

// MARK: - ProfileDetailNewView

struct ProfileDetailNewView: View {

    // MARK: - Private Properties

    @State private var description = ProfileDetailItem.getProfile().description
    @State private var status = ProfileDetailItem.getProfile().status
    @State private var name = ProfileDetailItem.getProfile().name
    @State private var code = ProfileDetailItem.getProfile().countryCode
    @State private var phone = ProfileDetailItem.getProfile().phone
    @State private var descriptionHeight = CGFloat(100)

    // MARK: - Internal Properties

    var profile: ProfileDetailItem

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: profile.image ?? UIImage())
                                .resizable()
                                .frame(width: geometry.size.width,
                                       height: 377)
                            ZStack {
                                Image(uiImage: UIImage())
                                    .frame(width: 60, height: 60)
                                    .background(.black(0.4))
                                    .clipShape(Circle())
                                Image(uiImage: R.image.profileDetail.camera() ?? UIImage())
                                    .frame(width: 45, height: 45)
                            }.padding([.trailing, .bottom], 16)
                        }
                        TextFieldStack(label: R.string.localizable.profileDetailStatusLabel(),
                                       text: $status,
                                       placeholder: "")
                            .padding([.leading, .trailing], 16)
                        TextViewStack(label: R.string.localizable.profileDetailStatusLabel(), text: $description,
                                      descriptionHeight: $descriptionHeight, placeholder: "Enter status")
                            .padding([.leading, .trailing], 16)
                        TextFieldStack(label: R.string.localizable.profileDetailNameLabel(),
                                       text: $name,
                                       placeholder: R.string.localizable.profileDetailNamePlaceholder())
                            .padding([.leading, .trailing], 16)
                        VStack(spacing: 8) {
                            CountryCodeView(countryCode: $code)
                            PhoneView(phone: $phone)
                                .background(
                                    CornerRadiusShape(radius: 8, corners: [.topLeft, .topRight])
                                        .fill(Color(.white()))
                                )
                        }
                        ActionView(image: R.image.profileDetail.socialNetwork() ?? UIImage(),
                                   text: R.string.localizable.profileDetailFirstItemCell(), color: .lightBlue())
                        Divider()
                        ActionView(image: R.image.profileDetail.exit() ?? UIImage(),
                                   text: R.string.localizable.profileDetailSecondItemCell(), color: .red(0.1))
                        ActionView(image: R.image.profileDetail.delete() ?? UIImage(),
                                   text: R.string.localizable.profileDetailThirdItemCell(), color: .red(0.1))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.profileDetailTitle())
                            .font(.bold(15))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                        }, label: {
                            Text(R.string.localizable.profileDetailRightButton())
                                .font(.bold(15))
                                .foregroundColor(.blue)
                        })
                    }
                }
            }
        }
    }
}

// MARK: - TextFieldStack

struct TextFieldStack: View {

    // MARK: - Internal Properties

    var label: String = ""
    @Binding var text: String
    var placeholder: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.bold(15))
                .foreground(.darkGray())
            TextField(placeholder, text: $text)
                .frame(height: 44)
                .font(.regular(15))
                .background(.lightBlue())
                .cornerRadius(8)
        }
    }
}

// MARK: - TextViewStack

struct TextViewStack: View {

    // MARK: - Internal Properties

    var label: String = ""
    @Binding var text: String
    @Binding var descriptionHeight: CGFloat
    var placeholder: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
        Text(label)
            .font(.bold(15))
            .foreground(.darkGray())
        ZStack(alignment: .topLeading) {
            DynamicHeightTextField(text: $text,
                                   height: $descriptionHeight)
                .font(.regular(15))
                .background(
                    CornerRadiusShape(radius: 8, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                        .fill(Color(.lightBlue()))
                )
                .frame(height: descriptionHeight)
                .cornerRadius(8)
        }
    }
    }
}

// MARK: - CountryCodeView

struct CountryCodeView: View {

    // MARK: - Internal Properties

    @Binding var countryCode: String
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State private var countryField: CountryCoderTextFieldView?
    let phoneNumberKit = PhoneNumberKit()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading,
               spacing: 8) {
            Text(R.string.localizable.profileDetailPhonePlaceholder())
                .padding(.leading, 16)
                .font(.bold(15))
                .foreground(.darkGray())
            HStack {
                self.countryField
                    .frame(height: 44)
                Image(uiImage: R.image.additionalMenu.grayArrow() ?? UIImage())
                    .padding(.trailing, 34)
            }.background(.lightBlue())
                .padding([.leading, .trailing], 16)
                .cornerRadius(8)
        }.onAppear {
            self.countryField = CountryCoderTextFieldView(phoneNumber: self.$countryCode)
        }
    }
}

// MARK: - PhoneView

struct PhoneView: View {

    // MARK: - Internal Properties

    @Binding var phone: String
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State private var phoneField: PhoneNumberTextFieldView?
    let phoneNumberKit = PhoneNumberKit()

    // MARK: - Body

    var body: some View {
        HStack {
            self.phoneField
                .frame(height: 44)
                .background(.lightBlue())
                .padding([.leading, .trailing], 16)
        }
        .onAppear {
            self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phone)
        }
    }
}

// MARK: - ActionView

struct ActionView: View {

    // MARK: - Internal Properties

    var image: UIImage
    var text: String
    var color: Palette

    // MARK: - Body

    var body: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 16) {
                ZStack {
                    Image(uiImage: UIImage())
                        .frame(width: 40, height: 40)
                        .background(color)
                        .clipShape(Circle())
                    Image(uiImage: image)
                        .frame(width: 20, height: 20)
                }.padding(.leading, 16)
                Text(text)
                    .font(.regular(15))
            }
        }
    }
}

// MARK: - ProfileDetailNewViewPreview
//
//struct ProfileDetailNewViewPreview: PreviewProvider {
//    static var previews: some View {
//        PhoneView(countryCode: "9511423367")
//    }
//}
