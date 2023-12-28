import SwiftUI

// MARK: - ChannelParticipantsRouter(ChannelParticipantsRouterable)

extension ChannelParticipantsRouter: ChannelParticipantsRouterable {
    
    func channelPatricipantsView(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>,
        coordinator: ChannelParticipantsFlowCoordinatorProtocol
    ) {
        state.path.append(BaseContentLink.channelPatricipants(viewModel: viewModel,
                                                              showParticipantsView: showParticipantsView,
                                                              coordinator: coordinator))
    }
    
    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int?,
        channelCoordinator: ChannelParticipantsFlowCoordinatorProtocol,
        onUsersSelected: @escaping ([Contact]) -> Void
    ) {
        print("dmdsmdsm,d  \(state.path)")
        state.path.append(BaseContentLink.selectContactsParticipants(mode: mode,
                                                                     chatData: chatData,
                                                                     contactsLimit: contactsLimit,
                                                                     channelParticipantsCoordinator: channelCoordinator,
                                                                     onUsersSelected: onUsersSelected))
        print("slaslaslsa  \(state.path)")
    }
}
