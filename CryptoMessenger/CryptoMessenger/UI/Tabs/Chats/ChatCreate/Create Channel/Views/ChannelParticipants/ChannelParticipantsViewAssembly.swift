import SwiftUI

// MARK: - ChannelParticipantsViewAssembly

enum ChannelParticipantsViewAssembly {
    
    static func build(_ viewModel: ChannelInfoViewModel,
                      _ showParticipantsView: Binding<Bool>,
                      _ coordinator: ChannelParticipantsFlowCoordinatorProtocol
    ) -> some View {
        print("dskasklaskl  \(coordinator)")
        let participantsViewModel = ChannelParticipantsViewModel()
        let view = ChannelParticipantsView(viewModel: viewModel,
                                           participantsViewModel: participantsViewModel,
                                           showParticipantsView: showParticipantsView)
        participantsViewModel.coordinator = coordinator
        return view
    }
}
