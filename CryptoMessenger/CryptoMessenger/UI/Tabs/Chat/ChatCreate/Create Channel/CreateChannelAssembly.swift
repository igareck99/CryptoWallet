import SwiftUI
import UIKit

enum CreateChannelAssemby {
    static func make(coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = CreateChannelViewModel(coordinator: coordinator)
        let view = CreateChannelView(viewModel: viewModel)
        return view
    }
}
