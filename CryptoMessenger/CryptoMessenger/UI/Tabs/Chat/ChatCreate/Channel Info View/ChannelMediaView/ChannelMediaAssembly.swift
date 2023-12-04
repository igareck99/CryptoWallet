import SwiftUI

enum ChannelMediaAssembly {
    static func build(room: AuraRoomData) -> some View {
        let viewModel = ChannelMediaViewModel(room: room)
        return ChannelMediaView(viewModel: viewModel)
    }
}
