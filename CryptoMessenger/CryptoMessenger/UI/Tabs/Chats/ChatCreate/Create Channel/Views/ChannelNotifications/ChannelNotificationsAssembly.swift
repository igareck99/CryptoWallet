import SwiftUI

enum ChannelNotificationsAssembly {
    static func build(roomId: String) -> some View {
        let viewModel = ChannelNotificationsViewModel(roomId: roomId)
        let view = ChannelNotificaionsView(viewModel: viewModel)
        return view
    }
}
