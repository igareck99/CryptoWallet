import SwiftUI
import UIKit

// MARK: - ChannelInfoAssembly

enum ChannelInfoAssembly {

    // MARK: - Static Properties

    static func build(
        roomId: String,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        isLeaveChannel: Binding<Bool>,
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>
    ) -> some View {
        let viewModel = ChannelInfoViewModel(
            roomId: roomId,
            chatData: chatData,
            saveData: saveData
        )
        viewModel.coordinator = coordinator
        let view = ChannelInfoView(
            viewModel: viewModel,
            isLeaveChannel: isLeaveChannel,
            resources: ChannelInfoResources.self
        )
        return view
    }
}
