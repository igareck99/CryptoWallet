import SwiftUI

// MARK: - ProfileSettingsMenu

enum ProfileSettingsMenu: CaseIterable, Identifiable {

    // MARK: - Types

    case profile, personalization, security, wallet, notifications
    case chat, storage, questions, about

    // MARK: - Internal Properties

    var id: UUID { UUID() }
    var result: (title: String, image: Image) {
        let strings = R.string.localizable.self
        let images = R.image.additionalMenu.self
        switch self {
        case .profile:
            return (strings.additionalMenuProfile(), images.profile.image)
        case .personalization:
            return (strings.additionalMenuPersonalization(), images.personalization.image)
        case .security:
            return (strings.additionalMenuSecurity(), images.security.image)
        case .wallet:
            return (strings.additionalMenuWallet(), images.wallet.image)
        case .notifications:
            return (strings.additionalMenuNotification(), images.notifications.image)
        case .chat:
            return (strings.additionalMenuChats(), images.chat.image)
        case .storage:
            return (strings.additionalMenuData(), images.dataStorage.image)
        case .questions:
            return (strings.additionalMenuQuestions(), images.questions.image)
        case .about:
            return (strings.additionalMenuAbout(), images.about.image)
        }
    }
}

// MARK: - ProfileSettingsMenuView

struct ProfileSettingsMenuView: View {

    // MARK: - Internal Properties

    let balance: String
    let onSelect: GenericBlock<ProfileSettingsMenu>

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)

            HStack(spacing: 8) {
                R.image.buyCellsMenu.aura.image
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(balance, [
                    .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                    .font(.regular(16)),
                    .color(.black())
                ])
                Spacer()
            }
            .padding(.top, 8)
            .padding([.leading, .trailing], 16)

            Divider()
                .foreground(.grayE6EAED())
                .padding(.top, 16)

            List {
                ForEach(ProfileSettingsMenu.allCases, id: \.self) { type in
                    if type == .questions {
                        Divider()
                            .listRowInsets(.init())
                            .foreground(.grayE6EAED())
                            .padding([.top, .bottom], 16)
                    }
                    ProfileSettingsMenuRow(title: type.result.title, image: type.result.image, notifications: 0)
                        .background(.white())
                        .frame(height: 64)
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                        .padding([.leading, .trailing], 16)
                        .onTapGesture { onSelect(type) }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - ProfileSettingsMenuRow

struct ProfileSettingsMenuRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image
    let notifications: Int

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(.blue(0.1)))
                    .frame(width: 40, height: 40)
                image
                    .frame(width: 20, height: 20)
            }

            Text(title)
                .font(.regular(15))
                .padding(.leading, 16)

            Spacer()

            if notifications > 0 {
                ZStack {
                    Image(uiImage: UIImage())
                        .frame(width: 20, height: 20)
                        .background(.lightRed())
                        .clipShape(Circle())
                    Text(notifications.description)
                        .font(.regular(15))
                        .foreground(.white())
                }
            }

            R.image.additionalMenu.grayArrow.image
        }
    }
}
