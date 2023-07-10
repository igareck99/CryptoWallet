import SwiftUI

// MARK: - ChannelNotificationsAssembly

enum ChannelNotificationsAssembly {

    static func build(_ roomId: String) -> some View {
        let viewModel = ChannelNotificationsViewModel(roomId: roomId)
        let view = ChannelNotificaionsView(viewModel: viewModel)
        return view
    }
}
