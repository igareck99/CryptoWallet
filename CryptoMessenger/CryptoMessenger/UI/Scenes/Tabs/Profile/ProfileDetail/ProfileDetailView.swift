import PhoneNumberKit
import SwiftUI

// MARK: - ProfileDetailType

enum ProfileDetailType: CaseIterable {

    // MARK: - Types

    case avatar, status, info, name, phone
    case socialNetwork, exit, delete

    // MARK: - Internal Properties

    var title: String {
        let strings = R.string.localizable.self
        switch self {
        case .status:
            return strings.profileDetailStatusLabel()
        case .info:
            return strings.profileDetailInfoLabel()
        case .name:
            return strings.profileDetailNameLabel()
        case .phone:
            return strings.profileDetailPhoneLabel()
        default:
            return ""
        }
    }
}

// MARK: - ProfileDetailView

struct ProfileDetailView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: ProfileDetailViewModel

    // MARK: - Private Properties

    @State private var descriptionHeight = CGFloat(100)
    @State private var showLogoutAlert = false
    @State private var showImagePicker = false
    @State private var isSaving = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Профиль", [
                        .font(.bold(15)),
                        .color(.black()),
                        .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                    ])
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSaving.toggle()
                        viewModel.send(.onDone)
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(.blue())
                    }).disabled(isSaving)
                }
            }
            .hideKeyboardOnTap()
            .onReceive(viewModel.$closeScreen) { closed in
                if closed {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $viewModel.selectedImage)
                    .ignoresSafeArea()
                    .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .alert(isPresented: $showLogoutAlert) {
                return Alert(
                    title: Text(R.string.localizable.profileDetailLogoutAlertTitle()),
                    message: Text(R.string.localizable.profileDetailLogoutAlertMessage()),
                    primaryButton: .default(Text(R.string.localizable.profileDetailLogoutAlertApprove()),
                                            action: { viewModel.send(.onLogout) }),
                    secondaryButton: .cancel(Text(R.string.localizable.profileDetailLogoutAlertCancel()))
                )
            }
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
                UITextView.appearance().showsVerticalScrollIndicator = false
                hideTabBar()
            }
            .onDisappear {
                viewModel.closeScreen = false
                showTabBar()
            }
    }

    var content: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(0..<ProfileDetailType.allCases.count, id: \.self) { index in
                            let type = ProfileDetailType.allCases[index]
                            switch type {
                            case .avatar:
                                avatarView.frame(height: geometry.size.width)
                            case .status:
                                TextFieldView(
                                    title: type.title.uppercased(),
                                    text: $viewModel.profile.status,
                                    placeholder: type.title
                                )
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .info:
                                info(type.title)
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .name:
                                TextFieldView(
                                    title: type.title.uppercased(),
                                    text: $viewModel.profile.name,
                                    placeholder: type.title
                                )
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .phone:
                                phone(type.title.uppercased())
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .socialNetwork:
                                ProfileDetailActionRow(
                                    title: "Ваши социальные сети",
                                    color: .blue(0.1),
                                    image: R.image.profileDetail.socialNetwork.image
                                )
                                    .onTapGesture {
                                        viewModel.send(.onSocial)
                                    }
                                    .background(.white())
                                    .frame(height: 64)
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .exit:
                                Divider()
                                    .foreground(.grayE6EAED())
                                    .padding(.top, 16)

                                ProfileDetailActionRow(
                                    title: "Выход",
                                    color: .lightRed(0.1),
                                    image: R.image.profileDetail.exit.image
                                )
                                    .background(.white())
                                    .frame(height: 64)
                                    .padding(.top, 16)
                                    .padding([.leading, .trailing], 16)
                                    .onTapGesture {
                                        vibrate()
                                        showLogoutAlert.toggle()
                                    }
                            case .delete:
                                ProfileDetailActionRow(
                                    title: "Удалить учетную запись",
                                    color: .lightRed(0.1),
                                    image: R.image.profileDetail.delete.image
                                )
                                    .background(.white())
                                    .frame(height: 64)
                                    .padding([.leading, .trailing], 16)
                            }
                        }
                    }
                }
            }

            if isSaving {
                ZStack {
                    ProgressView()
                        .tint(Color(.blue()))
                        .frame(width: 12, height: 12)
                }
            }
        }
        .background(isSaving ? .black(0.05) : .clear)
        .ignoresSafeArea()
    }

    private var avatarView: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                } else if let url = viewModel.profile.avatar {
                    AsyncImage(
                        url: url,
                        placeholder: {
                            ZStack {
                                ProgressView()
                                    .tint(Color(.blue()))
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.width)
                                    .background(.blue(0.1))
                            }
                        },
                        result: {
                            Image(uiImage: $0).resizable()
                        }
                    )
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                } else {
                    ZStack {
                        Rectangle()
                            .frame(height: geometry.size.width)
                            .foreground(.blue(0.1))
                        R.image.profile.avatarThumbnail.image
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }

                ZStack {
                    VStack(spacing: 0) {
                        Spacer()
                        HStack(spacing: 0) {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color(.black(0.4)))
                                    .frame(width: 60, height: 60)
                                R.image.profileDetail.camera.image
                            }
                            .onTapGesture {
                                showImagePicker = true
                            }
                            .padding([.trailing, .bottom], 16)
                        }
                    }
                }
            }
        }
    }

    private func info(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased(), [
                .font(.semibold(12)),
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left)),
                .color(.gray768286())

            ]).frame(height: 22)
            ZStack(alignment: .leading) {
                if viewModel.profile.info.isEmpty {
                    Text(title.firstUppercased)
                        .foreground(.gray768286(0.7))
                        .font(.regular(15))
                        .padding([.leading, .trailing], 16)
                }

                TextEditor(text: $viewModel.profile.info)
                    .foreground(.black())
                    .font(.regular(15))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 140)
                    .padding([.leading, .trailing], 14)
            }
            .background(.paleBlue())
            .cornerRadius(8)
        }
    }

    private func phone(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title, [
                .font(.semibold(12)),
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left)),
                .color(.gray768286())

            ]).frame(height: 22)

            HStack(spacing: 0) {
                Text("+7   Россия")
                    .foreground(.black())
                    .frame(height: 44)
                    .font(.regular(15))
                    .padding(.leading, 16)
                Spacer()
                R.image.profileDetail.arrow.image
                    .padding(.trailing, 16)
            }
            .background(.paleBlue())
            .cornerRadius(8)

            HStack(spacing: 0) {
                Text(viewModel.profile.phone)
                    .foreground(.black())
                    .frame(height: 44)
                    .font(.regular(15))
                    .padding(.leading, 16)
                Spacer()
            }
            .background(.paleBlue())
            .cornerRadius(8)
        }
    }
}

// MARK: - TextFieldView

struct TextFieldView: View {

    // MARK: - Internal Properties

    var title = ""
    @Binding var text: String
    var placeholder: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title, [
                .font(.semibold(12)),
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left)),
                .color(.gray768286())

            ]).frame(height: 22)
            HStack {
                TextField(placeholder, text: $text)
                    .foreground(.black())
                    .frame(height: 44)
                    .font(.regular(15))
                    .padding([.leading, .trailing], 16)
            }
            .background(.paleBlue())
            .cornerRadius(8)
        }
    }
}

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

// MARK: - ProfileDetailActionRow

struct ProfileDetailActionRow: View {

    // MARK: - Internal Properties

    let title: String
    let color: Palette
    let image: Image

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(color))
                    .frame(width: 40, height: 40)
                image
                    .frame(width: 20, height: 20)
            }
            Text(title)
                .font(.regular(15))
                .padding(.leading, 16)
            Spacer()
            R.image.additionalMenu.grayArrow.image
        }
    }
}
