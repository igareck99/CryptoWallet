import SwiftUI
import UIKit

enum ChannelInfoAssembly {
    static func build(
        room: AuraRoomData,
        coordinator: ChatsCoordinatable,
        isLeaveChannel: Binding<Bool>,
        chatData: Binding<ChatData>
    ) -> some View {
        let viewModel = ChannelInfoViewModel(
            room: room,
            chatData: chatData
        )
        viewModel.coordinator = coordinator
        let view = ChannelInfoView(
            viewModel: viewModel,
            resources: ChannelInfoResources.self
        )
        return view
    }
}
