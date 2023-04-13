import Foundation

// MARK: - ChannelMediaConfigurator

enum ChannelMediaConfigurator {

    // MARK: - Static Methods

    static func configuredView(
        room: AuraRoom,
        delegate: ChannelMediaSceneDelegate
    ) -> ChannelMediaView {
        let viewModel = ChatMediaViewModel(room: room)
        viewModel.delegate = delegate
        return ChannelMediaView(viewModel: viewModel)
    }
}
