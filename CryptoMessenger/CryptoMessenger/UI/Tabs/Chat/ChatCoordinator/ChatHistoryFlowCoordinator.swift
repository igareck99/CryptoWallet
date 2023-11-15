import SwiftUI

// MARK: - ChatHistoryFlowCoordinatorProtocol

protocol ChatHistoryFlowCoordinatorProtocol: Coordinator {
    func showImageViewer(imageUrl: URL?)
    func chatRoom(_ room: AuraRoomData)
    func firstAction(_ room: AuraRoom)
    func showCreateChat()
    func roomSettings(isChannel: Bool,
                      chatData: Binding<ChatData>,
                      room: AuraRoomData,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol)
    func chatMedia(_ room: AuraRoomData)
    func friendProfile(_ userId: String,
                       _ roomId: String)
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
        onUsersSelected: @escaping ([Contact]) -> Void
    )

    func dismissCurrentSheet()
    func chatActions(
        _ room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    )
    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>,
        onSendPlace: @escaping (Place) -> Void
    )

    func messageReactions(_ isCurrentUser: Bool,
                          _ isChannel: Bool,
                          _ userRole: ChannelRole,
                          _ onAction: @escaping GenericBlock<QuickActionCurrentUser>,
                          _ onReaction: @escaping GenericBlock<String>)

    func onContactTap(contactInfo: ChatContactInfo)
    func onMapTap(place: Place)
    func onDocumentTap(name: String, fileUrl: URL)
    func onVideoTap(url: URL)
    func chatMenu(_ tappedAction: @escaping (AttachAction) -> Void,
                  _ onCamera: @escaping () -> Void,
                  _ onSendPhoto: @escaping (UIImage) -> Void)
    func notSendedMessageMenu(_ event: RoomEvent,
                              _ onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void)
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
    
    deinit {
        print("ChatHistoryFlowCoordinator was deinit")
    }
}

// MARK: - ChatHistoryFlowCoordinator(Coordinator)

extension ChatHistoryFlowCoordinator: Coordinator {
    func start() {}
}

// MARK: - ContentFlowCoordinatorProtocol

extension ChatHistoryFlowCoordinator: ChatHistoryFlowCoordinatorProtocol {

    func onVideoTap(url: URL) {
        router.showVideo(url: url)
    }

    func onDocumentTap(name: String, fileUrl: URL) {
        router.showFile(name: name, fileUrl: fileUrl)
    }

    func showImageViewer(imageUrl: URL?) {
        router.showImageViewer(imageUrl: imageUrl)
    }

    func onMapTap(place: Place) {
        router.showMap(place: place, delegate: self)
    }

    func onContactTap(contactInfo: ChatContactInfo) {
        router.showContactInfo(contactInfo: contactInfo, delegate: self)
    }

    func firstAction(_ room: AuraRoom) {
        router.routeToFirstAction(room, coordinator: self)
    }

    func chatMedia(_ room: AuraRoomData) {
        router.chatMedia(room)
    }

    func roomSettings(isChannel: Bool,
                      chatData: Binding<ChatData>,
                      room: AuraRoomData,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol) {
        if isChannel || !room.isDirect {
            router.channelSettings(chatData: chatData,
                                   room: room,
                                   isLeaveChannel: isLeaveChannel,
                                   coordinator: coordinator)
        } else {
            router.chatSettings(chatData: chatData,
                                room: room,
                                isLeaveChannel: isLeaveChannel,
                                coordinator: coordinator)
        }
    }

    func friendProfile(_ userId: String,
                       _ roomId: String) {
        router.friendProfile(userId, roomId, self)
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
            self?.router.chatCreate(router) {
                self?.removeChildCoordinator(coordinator)
                self?.router.dismissCurrentSheet()
            }
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
        sendLocation: Binding<Bool>,
        onSendPlace: @escaping (Place) -> Void
    ) {
        router.presentLocationPicker(
            place: place,
            sendLocation: sendLocation,
            onSendPlace: onSendPlace
        )
    }

    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        onUsersSelected: @escaping ([Contact]) -> Void
    ) {
        router.showSelectContact(
            mode: mode,
            chatData: chatData,
            contactsLimit: contactsLimit,
            coordinator: self,
            onUsersSelected: onUsersSelected
        )
    }
    
    func chatRoom(_ room: AuraRoomData) {
        router.chatRoom(room, self)
    }
    
    func messageReactions(_ isCurrentUser: Bool,
                          _ isChannel: Bool,
                          _ userRole: ChannelRole,
                          _ onAction: @escaping GenericBlock<QuickActionCurrentUser>,
                          _ onReaction: @escaping GenericBlock<String>) {
        router.messageReactions(
            isCurrentUser,
            isChannel,
            userRole,
            onAction,
            onReaction
        )
    }
    
    func chatMenu(_ tappedAction: @escaping (AttachAction) -> Void,
                  _ onCamera: @escaping () -> Void,
                  _ onSendPhoto: @escaping (UIImage) -> Void) {
        router.chatMenu(tappedAction, onCamera, onSendPhoto)
    }
    
    func notSendedMessageMenu(_ event: RoomEvent,
                              _ onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void) {
        router.notSendedMessageMenu(event, onTapItem)
    }
}

// MARK: - ContactInfoViewModelDelegate

extension ChatHistoryFlowCoordinator: ContactInfoViewModelDelegate {
    func didTapClose() {
        router.dismissCurrentSheet()
    }
}

// MARK: - AuraMapViewModelDelegate

extension ChatHistoryFlowCoordinator: AuraMapViewModelDelegate {
    func didTapOpenOtherAppView(place: Place, showLocationTransition: Binding<Bool>) {
        router.showOpenOtherApp(
            place: place,
            showLocationTransition: showLocationTransition
        )
    }
}
