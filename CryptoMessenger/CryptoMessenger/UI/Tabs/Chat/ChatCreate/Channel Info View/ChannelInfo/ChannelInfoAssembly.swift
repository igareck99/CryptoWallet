import SwiftUI
import UIKit

// MARK: - ChannelInfoAssembly

enum ChannelInfoAssembly {

    // MARK: - Static Properties

    static func build(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
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
