import SwiftUI
import UIKit

enum ChannelInfoAssembly {
    static func build(roomId: String) -> some View {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
        let view = ChannelInfoView(
            viewModel: viewModel,
            resources: ChannelInfoResources.self
        )
        return view
    }
    
    static func make(roomId: String, delegate: ChannelInfoSceneDelegate?) -> UIViewController {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
        viewModel.delegate = delegate
        let view = ChannelInfoView(
            viewModel: viewModel,
            resources: ChannelInfoResources.self
        )
        let controller = BaseHostingController(rootView: view)
        return controller
    }
}
