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
                    Text("Готово")
                        .foreground(.blue())
                        .font(.semibold(15))
                        .onTapGesture { viewModel.send(.onDone) }
                }
            }
            .hideKeyboardOnTap()
            .onReceive(viewModel.$closeScreen) { closed in
                if closed {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .alert(isPresented: $showLogoutAlert) {
                return Alert(
                    title: Text("Выйти из учетной записи?"),
                    message: Text("Вы действительно хотите выйти из учетной записи? Перед выходом проверьте сохранили ли вы ключ."),
                    primaryButton: .default(Text("Выход"), action: { viewModel.send(.onLogout) }),
                    secondaryButton: .cancel(Text("Отменить"))
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
    }

    private var avatarView: some View {
        GeometryReader { geometry in
            ZStack {
                if let url = viewModel.profile.avatar {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image.resizable()
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
                    }
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.width)
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

            //PhoneView(phone: $viewModel.profile.phone)
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
