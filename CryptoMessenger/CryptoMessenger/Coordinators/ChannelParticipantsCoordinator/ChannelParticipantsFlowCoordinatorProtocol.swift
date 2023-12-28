import SwiftUI

// MARK: - ChatCreateFlowCoordinatorProtocol

protocol ChannelParticipantsFlowCoordinatorProtocol {
    
    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int?,
        channelCoordinator: ChannelParticipantsFlowCoordinatorProtocol,
        onUsersSelected: @escaping ([Contact]) -> Void
    )
    
    func onUserProfile(_ userId: String, _ roomId: String)
}
