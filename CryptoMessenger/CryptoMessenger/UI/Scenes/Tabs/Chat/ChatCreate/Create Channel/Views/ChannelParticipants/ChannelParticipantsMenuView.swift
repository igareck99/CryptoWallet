import SwiftUI

// MARK: - ChannelParticipantsMenuView

struct ChannelParticipantsMenuView: View {

    // MARK: - Internal Properties

    @Binding var showMenuView: Bool
    var data: ChannelParticipantsData?
    let sections: [ChannelUserMenuAction] = [.init(image: R.image.channelSettings.user() ?? UIImage(),
                                                   action: .open),
                                             .init(image: R.image.channelSettings.pencil() ?? UIImage(),
                                                   action: .change),
                                             .init(image: R.image.channelSettings.brush() ?? UIImage(),
                                                   action: .delete)]
    let onAction: GenericBlock<ChannelParticipantsData>

    // MARK: - Private Properties

    @State private var showRoleActionSheet = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
            listView
            .padding(.bottom, 6)
        }
        .actionSheet(isPresented: $showRoleActionSheet) {
            ActionSheet(title: Text("Выберите роль для участника"),
                        message: Text(
                                        """
                                        Если вы передаете роль - Владелец другому пользователю,
                                        то самостоятельно нельзя будет вернуть себе роль.
                                        """
                        ),
                        buttons: [
                            .cancel(),
                            .default(
                                Text(ChannelRole.owner.text),
                                action: { changeRole(.owner) }
                            ),
                            .default(
                                Text(ChannelRole.admin.text),
                                action: { changeRole(.admin) }
                            ),
                            .default(
                                Text(ChannelRole.user.text),
                                action: { changeRole(.user) }
                            )
                        ]
            )
        }
    }

    // MARK: - Private Properties

    private var listView: some View {
        ForEach(sections, id: \.self) { item in
            HStack {
                HStack(spacing: 13) {
                    Image(uiImage: item.image)
                        .scaledToFill()
                    Text(item.action.rawValue)
                        .font(.regular(16))
                        .foreground(item.action == .delete ? .red() : .black())
                }
                Spacer()
                R.image.chatSettings.chevron.image
                    .opacity(item.action == .open ? 1 : 0)
            }
            .frame(height: 57)
            .padding(.horizontal, 22)
            .onTapGesture {
                switch item.action {
                case .open:
                    withAnimation(.linear(duration: 0.5)) {
                        showRoleActionSheet = true
                    }
                    showMenuView = false
                default:
                    break
                }
            }
        }
    }

    // MARK: - Private Methods

    private func changeRole(_ role: ChannelRole) {
        guard let value = data else { return }
        onAction(ChannelParticipantsData(name: value.name,
                                         matrixId: value.matrixId,
                                         role: role))
    }
}
