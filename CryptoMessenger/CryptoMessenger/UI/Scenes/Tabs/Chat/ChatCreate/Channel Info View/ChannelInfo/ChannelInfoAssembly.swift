import SwiftUI
import UIKit

// MARK: - ChannelInfoAssembly

enum ChannelInfoAssembly {

    // MARK: - Static Properties
  
    static func build(
        roomId: String,
        isLeaveChannel: Binding<Bool>,
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>
    ) -> some View {
        let viewModel = ChannelInfoViewModel(
            roomId: roomId,
            chatData: chatData,
            saveData: saveData
        )
        let view = ChannelInfoView(
            viewModel: viewModel,
            isLeaveChannel: isLeaveChannel,
            resources: ChannelInfoResources.self
        )
        return view
    }

    static func make(
        roomId: String,
        isLeaveChannel: Binding<Bool>,
        delegate: ChannelInfoSceneDelegate?,
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>
    ) -> UIViewController {
        let viewModel = ChannelInfoViewModel(
            roomId: roomId,
            chatData: chatData,
            saveData: saveData
        )
        viewModel.delegate = delegate
        let view = ChannelInfoView(
            viewModel: viewModel,
            isLeaveChannel: isLeaveChannel,
            resources: ChannelInfoResources.self
        )
        let controller = BaseHostingController(rootView: view)
        return controller
    }
}
