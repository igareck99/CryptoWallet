import Foundation
import SwiftUI

// MARK: - ChannelInfoConfigurator

enum ChannelInfoConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChannelInfoSceneDelegate?,
                               roomId: String) -> ChannelInfoView<ChannelInfoViewModel> {
        let viewModel = ChannelInfoViewModel(roomId: roomId)
        viewModel.delegate = delegate
        let view = ChannelInfoView(
            viewModel: viewModel,
            resources: ChannelInfoResources.self
        )
        return view
    }
}
