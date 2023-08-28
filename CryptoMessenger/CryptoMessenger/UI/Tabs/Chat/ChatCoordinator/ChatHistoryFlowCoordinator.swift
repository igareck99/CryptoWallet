import SwiftUI

// MARK: - ChatHistoryFlowCoordinatorProtocol

protocol ChatHistoryFlowCoordinatorProtocol: Coordinator {
    func firstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)
    func showCreateChat()
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
    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void)
    func galleryPickerSheet(sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent,
                            onSelectImage: @escaping (UIImage?) -> Void,
                            onSelectVideo: @escaping (URL?) -> Void)
    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>)
    func showDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    )

    func presentDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    )
    
    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int?,
        onSelectContact: GenericBlock<[Contact]>?
    )

    func dismissCurrentSheet()
    func chatActions(
        _ room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    )
    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>
    )
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

    func showCreateChat() {
        let coordinator = ChatCreateCoordinatorAssembly.buld() { coordinator in
            self.removeChildCoordinator(coordinator)
            self.router.dismissCurrentSheet()
        }
        addChildCoordinator(coordinator)
        coordinator.startWithView { [weak self] router in
            self?.router.chatCreate(router)
        }
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

    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void) {
        router.galleryPickerFullScreen(sourceType: sourceType,
                                       galleryContent: galleryContent,
                                       onSelectImage: onSelectImage,
                                       onSelectVideo: onSelectVideo)
    }
    
    func galleryPickerSheet(sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent,
                            onSelectImage: @escaping (UIImage?) -> Void,
                            onSelectVideo: @escaping (URL?) -> Void) {
        router.galleryPickerSheet(sourceType: sourceType,
                                  galleryContent: galleryContent,
                                  onSelectImage: onSelectImage,
                                  onSelectVideo: onSelectVideo)
    }

    func showDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        router.showDocumentPicker(
            onCancel: onCancel,
            onDocumentsPicked: onDocumentsPicked
        )
    }

    func presentDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        router.presentDocumentPicker(
            onCancel: onCancel,
            onDocumentsPicked: onDocumentsPicked
        )
    }

    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>) {
        router.channelPatricipantsView(viewModel,
                                       showParticipantsView: showParticipantsView)
    }

    func dismissCurrentSheet() {
        router.dismissCurrentSheet()
    }

    func chatActions(_ room: ChatActionsList, onSelect: @escaping GenericBlock<ChatActions>) {
        router.chatActions(room, onSelect: onSelect)
    }

    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>
    ) {
        router.presentLocationPicker(
            place: place,
            sendLocation: sendLocation
        )
    }

    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        onSelectContact: GenericBlock<[Contact]>? = nil
    ) {
        router.showSelectContact(
            mode: mode,
            chatData: chatData,
            contactsLimit: contactsLimit,
            onSelectContact: onSelectContact
        )
    }
}
