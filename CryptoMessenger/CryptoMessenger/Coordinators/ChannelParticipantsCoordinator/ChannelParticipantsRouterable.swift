import SwiftUI

// MARK: - ChannelParticipantsRouterable

protocol ChannelParticipantsRouterable: View {
    
    func channelPatricipantsView(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>,
        coordinator: ChannelParticipantsFlowCoordinatorProtocol
    )
    
    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int?,
        channelCoordinator: ChannelParticipantsFlowCoordinatorProtocol,
        onUsersSelected: @escaping ([Contact]) -> Void
    ) 
}
