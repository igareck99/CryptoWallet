import SwiftUI
import UIKit

enum ChannelInfoAssembly {
    static func build(roomId: String) -> some View {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
        let view = ChannelInfoView(viewModel: viewModel)
        return view
    }
    
    static func make(roomId: String, delegate: ChatRoomSceneDelegate?) -> UIViewController {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
        viewModel.delegate = delegate
        let view = ChannelInfoView(viewModel: viewModel)
        let controller = BaseHostingController(rootView: view)
        return controller
    }
}
