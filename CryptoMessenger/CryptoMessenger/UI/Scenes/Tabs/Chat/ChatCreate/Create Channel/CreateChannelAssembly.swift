import SwiftUI
import UIKit

enum CreateChannelAssemby {
    
    static func build(onCreationEnd: @escaping VoidBlock) -> UIViewController {
        let viewModel = CreateChannelViewModel(onChannelCreationEnd: onCreationEnd)
        let view = CreateChannelView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    static func make(onCreationEnd: @escaping VoidBlock) -> some View {
        let viewModel = CreateChannelViewModel(onChannelCreationEnd: onCreationEnd)
        let view = CreateChannelView(viewModel: viewModel)
        return view
    }
}
