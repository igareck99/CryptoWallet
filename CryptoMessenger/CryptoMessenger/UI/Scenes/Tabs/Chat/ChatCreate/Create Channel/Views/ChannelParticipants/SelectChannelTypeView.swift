import SwiftUI

// MARK: - SelectChannelTypeView

struct SelectChannelTypeView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: SelectChannelTypeViewModel
    @Binding var showChannelChangeType: Bool

    // MARK: - Private Properties

    var ontypeSelected: (SelectChannelTypeEnum) -> Void

    // MARK: - Body

    var body: some View {
        List {
            publicChannelView()
                .listRowSeparator(.visible)
            privateChannelView()
                .listRowSeparator(.visible)
            if viewModel.isPrivateSelected {
                encrytionView()
                    .listRowSeparator(.hidden)
            }
        }
        .padding(.top, 9)
        .listStyle(.plain)
        .navigationBarTitle("", displayMode: .inline)
        .scrollDisabled(true)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showChannelChangeType = false
                }, label: {
                    R.image.navigation.backButton.image
                })
            }
            ToolbarItem(placement: .principal) {
                Text("Тип канала")
                    .font(.bold(17))
                    .foreground(.black())
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.updateRoomState()
                    showChannelChangeType = false
                }, label: {
                    Text("Готово")
                        .font(.semibold(15))
                        .foregroundColor(.lapisLazuli)
                })
            }
        }
    }

    // MARK: - Private Methods

    private func publicChannelView() -> some View {
        ChannelTypeView(
            title: "Публичный канал",
            text: "Публичные каналы можно найти через поиск, подписаться на них может любой пользователь.",
            channelType: .publicChannel,
            isSelected: $viewModel.isPublicSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            withAnimation(.linear(duration: 0.5)) {
                viewModel.isPrivateSelected = false
                ontypeSelected(.publicChannel)
            }
        }
        .background(.white())
    }

    private func privateChannelView() -> some View {
        ChannelTypeView(
            title: "Частный канал",
            text: "На частные каналы можно подписаться только по ссылке-приглашению.",
            channelType: .privateChannel,
            isSelected: $viewModel.isPrivateSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            withAnimation(.linear(duration: 0.5)) {
                viewModel.isPublicSelected = false
                ontypeSelected(.privateChannel)
            }
        }
        .background(.white())
    }

    private func encrytionView() -> some View {
        EncryptionStateView(
            title: "Шифрование",
            text: "Обратите внимание, что если вы включите шифрование, в дальнейшем его нельзя будет отключить",
            isEncrypted: $viewModel.isEncryptionEnabled
        )
    }
}

// MARK: - SelectChannelTypeEnum

enum SelectChannelTypeEnum {

    case publicChannel
    case privateChannel
    case encryptedChannel
}
