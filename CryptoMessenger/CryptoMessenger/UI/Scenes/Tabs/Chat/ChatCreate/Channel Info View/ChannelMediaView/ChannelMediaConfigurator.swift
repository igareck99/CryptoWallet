import SwiftUI

// MARK: - ChannelMediaConfigurator

enum ChannelMediaAssembly {

    // MARK: - Static Methods

    static func build(
        room: AuraRoom
    ) -> some View {
        let viewModel = ChannelMediaViewModel(room: room)
        return ChannelMediaView(viewModel: viewModel)
    }
}
