import SwiftUI

// MARK: - ChatsCoordinator

final class ChatsCoordinator<Router: ChatsRouterable> {
    private let router: Router
    var childCoordinators = [String: Coordinator]()
    var navigationController = UINavigationController()
    @Published var childPath = NavigationPath()
    @Published var presentedLink: BaseSheetLink?

    init(
        router: Router
    ) {
        self.router = router
    }

    deinit {
        debugPrint("ChatHistoryFlowCoordinator was deinit")
    }
}

// MARK: - Coordinator

extension ChatsCoordinator: Coordinator {
    func start() {}
}

// MARK: - ChatsCoordinatable

extension ChatsCoordinator: ChatsCoordinatable {

    func onVideoTap(url: URL) {
        router.showVideo(url: url)
    }

    func onDocumentTap(name: String, fileUrl: URL) {
        router.showFile(name: name, fileUrl: fileUrl)
    }

    func showImageViewer(image: Image?, imageUrl: URL?) {
        router.showImageViewer(image: image, imageUrl: imageUrl)
    }

    func onMapTap(place: Place) {
        router.showMap(place: place, delegate: self)
    }

    func onContactTap(contactInfo: ChatContactInfo) {
        router.showContactInfo(contactInfo: contactInfo, delegate: self)
    }

    func firstAction(room: AuraRoom) {
        router.routeToFirstAction(room: room, coordinator: self)
    }

    func chatMedia(room: AuraRoomData) {
        router.chatMedia(room: room)
    }

    func roomSettings(
        isChannel: Bool,
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatsCoordinatable
    ) {
        if isChannel || !room.isDirect {
            router.channelSettings(
                chatData: chatData,
                room: room,
                isLeaveChannel: isLeaveChannel,
                coordinator: coordinator
            )
        } else {
            router.chatSettings(
                chatData: chatData,
                room: room,
                isLeaveChannel: isLeaveChannel,
                coordinator: coordinator
            )
        }
    }

    func friendProfile(
        userId: String,
        roomId: String
    ) {
        router.friendProfile(
            userId: userId,
            roomId: roomId,
            coordinator: self
        )
    }

    // MARK: - ???
    func friendProfile(contact: Contact) {}

    func adminsView(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    ) {
        router.adminsView(
            chatData: chatData,
            coordinator: coordinator
        )
    }
    
    

    func showCreateChat() {
        let coordinator = ChatCreateCoordinatorAssembly.buld { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.router.dismissCurrentSheet()
        } onFriendProfile: { [weak self] room in
            self?.router.dismissCurrentSheet()
            self?.chatRoom(room: room)
        }
        addChildCoordinator(coordinator)
        coordinator.startWithView { [weak self] router in
            self?.router.chatCreate(view: router) { [weak self] in
                self?.removeChildCoordinator(coordinator)
                self?.router.dismissCurrentSheet()
            }
        }
    }

    func chatMembersView(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    ) {
        router.chatMembersView(
            chatData: chatData,
            coordinator: coordinator
        )
    }

    func notifications(roomId: String) {
        router.notifications(roomId)
    }

    func popToRoot() {
        router.popToRoot()
    }

    func previousScreen() {
        router.previousScreen()
    }

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) {
        router.galleryPickerFullScreen(
            sourceType: sourceType,
            galleryContent: galleryContent,
            onSelectImage: onSelectImage,
            onSelectVideo: onSelectVideo
        )
    }

    func galleryPickerSheet(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) {
        router.galleryPickerSheet(
            sourceType: sourceType,
            galleryContent: galleryContent,
            onSelectImage: onSelectImage,
            onSelectVideo: onSelectVideo
        )
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

    func channelPatricipantsView(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>
    ) {
        // TODO: Сделать через роутер
        let coordinator = ChannelParticipantsCoordinatorAssembly.build(viewModel,
                                                                       showParticipantsView,
                                                                       router.navPathChild(), { userId, roomId  in
            self.friendProfile(userId: userId, roomId: roomId)
        })
        addChildCoordinator(coordinator)
        coordinator.startWithView { [weak self] router in
            self?.router.channelParticipantsViewCreate(view: router,
                                                       onDisappear: { [weak self] in
                self?.removeChildCoordinator(coordinator)
                self?.router.dismissCurrentSheet()
                self?.childPath = NavigationPath()
            })
        }
    }

    func dismissCurrentSheet() {
        router.dismissCurrentSheet()
    }

    func chatActions(
        room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    ) {
        router.chatActions(
            room: room,
            onSelect: onSelect
        )
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

    func chatRoom(room: AuraRoomData, roomOpenState: RoomOpenState = .chatHistory) {
        router.chatRoom(
            room: room,
            roomOpenState: roomOpenState,
            coordinator: self
        )
    }

    func messageReactions(
        messageType: MessageType,
        hasReactions: Bool,
        hasAccessToWrite: Bool,
        isCurrentUser: Bool,
        isChannel: Bool,
        userRole: ChannelRole,
        onAction: @escaping GenericBlock<QuickActionCurrentUser>,
        onReaction: @escaping GenericBlock<String>
    ) {
        router.messageReactions(
            messageType: messageType,
            hasReactions: hasReactions,
            hasAccessToWrite: hasAccessToWrite,
            isCurrentUser: isCurrentUser,
            isChannel: isChannel,
            userRole: userRole,
            onAction: onAction,
            onReaction: onReaction
        )
    }

    func chatMenu(model: ActionsViewModel) {
        router.chatMenu(model: model)
    }

    func notSendedMessageMenu(
        event: RoomEvent,
        onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void
    ) {
        router.notSendedMessageMenu(
            event: event,
            onTapItem: onTapItem
        )
    }

    func showTransactionStatus(model: TransactionStatus) {
        router.showTransactionStatus(model: model)
    }

    func transferCrypto(
        wallet: WalletInfo,
        receiverData: UserReceiverData?,
        onTransferCompletion: @escaping (TransactionResult) -> Void
    ) {
        let transferCoordinator = TransferCoordinatorAssembly.build(
            wallet: wallet,
            receiverData: receiverData,
            path: router.routePath(),
            presentedItem: router.presentedItem()
        ) { [weak self] coordinator, rawTransaction in
            self?.removeChildCoordinator(coordinator)
            onTransferCompletion(rawTransaction)
        }
        addChildCoordinator(transferCoordinator)
        transferCoordinator.start()
    }
}

// MARK: - ContactInfoViewModelDelegate

extension ChatsCoordinator: ContactInfoViewModelDelegate {
    func didTapClose() {
        router.dismissCurrentSheet()
    }
}

// MARK: - AuraMapViewModelDelegate

extension ChatsCoordinator: AuraMapViewModelDelegate {
    func didTapOpenOtherAppView(
        place: Place,
        showLocationTransition: Binding<Bool>
    ) {
        router.showOpenOtherApp(
            place: place,
            showLocationTransition: showLocationTransition
        )
    }
}
