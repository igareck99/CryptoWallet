import SwiftUI

// MARK: - ChatHistoryFlowCoordinatorProtocol

protocol ChatHistoryFlowCoordinatorProtocol: Coordinator {
    func firstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)
    func showCreateChat(_ chatData: Binding<ChatData>)
    func roomSettings(isChannel: Bool,
                      chatData: Binding<ChatData>,
                      saveData: Binding<Bool>,
                      room: AuraRoom,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol)
    func chatMedia(_ room: AuraRoom)
    func friendProfile(_ contact: Contact)
    func adminsView( _ chatData: Binding<ChatData>,
                     _ coordinator: ChatHistoryFlowCoordinatorProtocol)
    func chatMembersView(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatHistoryFlowCoordinatorProtocol)
    func notifications(_ roomId: String)
    func popToRoot()
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent)
    func galleryPickerSheet(selectedImage: Binding<UIImage?>,
                            selectedVideo: Binding<URL?>,
                            sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent)
    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>)
    func dismissCurrentSheet()
}

// MARK: - ChatHistoryFlowCoordinator

final class ChatHistoryFlowCoordinator<Router: ChatHistoryRouterable> {
    private let router: Router
    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    
    init(
        router: Router
    ) {
        self.router = router
    }
}

// MARK: - ChatHistoryFlowCoordinator(Coordinator)

extension ChatHistoryFlowCoordinator: Coordinator {
    func start() {
    }
}

// MARK: - ContentFlowCoordinatorProtocol

extension ChatHistoryFlowCoordinator: ChatHistoryFlowCoordinatorProtocol {

    func firstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol) {
        router.routeToFirstAction(room, coordinator: coordinator)
    }

    func chatMedia(_ room: AuraRoom) {
        router.chatMedia(room)
    }

    func roomSettings(isChannel: Bool,
                      chatData: Binding<ChatData>,
                      saveData: Binding<Bool>,
                      room: AuraRoom,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol) {
        if isChannel {
            router.channelSettings(chatData: chatData,
                                   saveData: saveData,
                                   room: room,
                                   isLeaveChannel: isLeaveChannel,
                                   coordinator: coordinator)
        } else {
            router.chatSettings(chatData: chatData,
                                saveData: saveData,
                                room: room,
                                isLeaveChannel: isLeaveChannel,
                                coordinator: coordinator)
        }
    }

    func friendProfile(_ contact: Contact) {
        router.friendProfile(contact)
    }

    func adminsView(
        _ chatData: Binding<ChatData>,
        _ coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        router.adminsView(chatData, coordinator)
    }

    func showCreateChat(_ chatData: Binding<ChatData>) {
        let coordinator = ChatCreateCoordinatorAssembly.buld(path: router.routePath(),
                                                             presentedItem: router.presentedItem(),
                                                             chatData: chatData) { coordinator in
            self.removeChildCoordinator(coordinator)
        }
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    func chatMembersView(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatHistoryFlowCoordinatorProtocol) {
        router.chatMembersView(chatData, coordinator)
    }

    func notifications(_ roomId: String) {
        router.notifications(roomId)
    }

    func popToRoot() {
        router.popToRoot()
    }

    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent) {
        router.galleryPickerFullScreen(selectedImage: selectedImage,
                                       selectedVideo: selectedVideo,
                                       sourceType: sourceType,
                                       galleryContent: galleryContent)
    }
    
    func galleryPickerSheet(selectedImage: Binding<UIImage?>,
                            selectedVideo: Binding<URL?>,
                            sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent) {
        router.galleryPickerSheet(selectedImage: selectedImage,
                                  selectedVideo: selectedVideo,
                                  sourceType: sourceType,
                                  galleryContent: galleryContent)
    }

    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>) {
        router.channelPatricipantsView(viewModel,
                                       showParticipantsView: showParticipantsView)
    }
    
    func dismissCurrentSheet() {
        router.dismissCurrentSheet()
    }
}
