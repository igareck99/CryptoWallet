import SwiftUI

// MARK: - ChannelParticipantsCoordinatorAssembly

enum ChannelParticipantsCoordinatorAssembly {
    static func build(_ viewModel: ChannelInfoViewModel,
                      _ showParticipantsView: Binding<Bool>,
                      _ path: Binding<NavigationPath>,
                      _ ouUserProfile: @escaping (String, String) -> Void) -> Coordinator {
        let state = ChannelParticipantsRouterState(path: path)
        let participantsViewModel = ChannelParticipantsViewModel()
        let view = ChannelParticipantsView(viewModel: viewModel,
                                           participantsViewModel: participantsViewModel,
                                           showParticipantsView: showParticipantsView)
        let router = ChannelParticipantsRouter(state: state,
                                               factory: ViewsBaseFactory.self,
                                               content: {
            view
        })
        let coordinator = ChannelParticipantsCoordinator(router: router,
                                                         viewModel: viewModel,
                                                         showParticipantsView: showParticipantsView,
                                                         ouUserProfile: ouUserProfile)
        participantsViewModel.coordinator = coordinator
        return coordinator
    }
}
