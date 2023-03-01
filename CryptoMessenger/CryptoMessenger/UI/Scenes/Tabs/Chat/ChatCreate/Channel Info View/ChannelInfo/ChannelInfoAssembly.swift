import SwiftUI
import UIKit

// MARK: - ChannelInfoAssembly

enum ChannelInfoAssembly {
    
    // MARK: - Static Properties
    
    static func build(roomId: String, isLeaveChannel: Binding<Bool>) -> some View {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
        let view = ChannelInfoView(
            viewModel: viewModel,
            isLeaveChannel: isLeaveChannel,
            resources: ChannelInfoResources.self
        )
        return view
    }
    
    static func make(roomId: String,
                     isLeaveChannel: Binding<Bool>,
                     delegate: ChannelInfoSceneDelegate?) -> UIViewController {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
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
