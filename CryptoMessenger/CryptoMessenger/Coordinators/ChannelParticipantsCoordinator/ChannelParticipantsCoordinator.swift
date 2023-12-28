import SwiftUI
import UIKit

// MARK: - ChatCreateFlowCoordinator

final class ChannelParticipantsCoordinator<Router: ChannelParticipantsRouterable> {

    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    private var router: Router
    var viewModel: ChannelInfoViewModel
    @Binding var showParticipantsView: Bool
    var ouUserProfile: (String, String) -> Void

    init(
        router: Router,
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>,
        ouUserProfile: @escaping (String, String) -> Void
    ) {
        self.router = router
        self.viewModel = viewModel
        self._showParticipantsView = showParticipantsView
        self.ouUserProfile = ouUserProfile
    }
}

// MARK: - ChatCreateFlowCoordinator(Coordinator)

extension ChannelParticipantsCoordinator: Coordinator {
    func start() {
        router.channelPatricipantsView(viewModel: self.viewModel,
                                       showParticipantsView: self.$showParticipantsView, coordinator: self)
    }

    func startWithView(completion: @escaping RootViewBuilder) {
       completion(router)
    }
}

// MARK: - ChannelParticipantsCoordinator(ChannelParticipantsFlowCoordinatorProtocol)

extension ChannelParticipantsCoordinator: ChannelParticipantsFlowCoordinatorProtocol {
    
    func showSelectContact(mode: ContactViewMode, chatData: Binding<ChatData>,
                           contactsLimit: Int?,
                           channelCoordinator: ChannelParticipantsFlowCoordinatorProtocol,
                           onUsersSelected: @escaping ([Contact]) -> Void) {
        router.showSelectContact(mode: mode, chatData: chatData, contactsLimit: contactsLimit,
                                 channelCoordinator: channelCoordinator,
                                 onUsersSelected: onUsersSelected)
    }
    
    func onUserProfile(_ userId: String, _ roomId: String) {
        ouUserProfile(userId, roomId)
    }
}
