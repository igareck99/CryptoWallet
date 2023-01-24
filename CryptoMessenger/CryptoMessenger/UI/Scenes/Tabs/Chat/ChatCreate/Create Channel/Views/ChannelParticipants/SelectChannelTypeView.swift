import SwiftUI

// MARK: - SelectChannelTypeView

struct SelectChannelTypeView: View {

    // MARK: - Internal Properties

    @Binding var showChannelChangeType: Bool

    // MARK: - Private Properties

    @State private var isPublicSelected = true
    @State private var isPrivateSelected = false
    @State private var isEncryptionEnabled = false

    // MARK: - Body

    var body: some View {
        List {
            publicChannelView()
                .listRowSeparator(.visible)
            privateChannelView()
                .listRowSeparator(.visible)
            if isPrivateSelected {
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
                    showChannelChangeType = false
                }, label: {
                    Text("Готово")
                        .font(.semibold(15))
                        .foregroundColor(.azureRadianceApprox)
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
            isSelected: $isPublicSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            withAnimation(.linear(duration: 0.5)) {
                isPrivateSelected = false
            }
        }
        .background(.white())
    }

    private func privateChannelView() -> some View {
        ChannelTypeView(
            title: "Частный канал",
            text: "На частные каналы можно подписаться только по ссылке-приглашению.",
            channelType: .publicChannel,
            isSelected: $isPrivateSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            withAnimation(.linear(duration: 0.5)) {
                isPublicSelected = false
            }
        }
        .background(.white())
    }

    private func encrytionView() -> some View {
        EncryptionStateView(
            title: "Шифрование",
            text: "Обратите внимание, что если вы включите шифрование, в дальнейшем его нельзя будет отключить",
            isEncrypted: $isEncryptionEnabled
        )
    }
}
