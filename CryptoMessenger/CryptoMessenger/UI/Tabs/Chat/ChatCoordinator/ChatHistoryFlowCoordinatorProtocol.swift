import SwiftUI

protocol ChatHistoryFlowCoordinatorProtocol: Coordinator {
    func showImageViewer(image: Image?, imageUrl: URL?)

    func chatRoom(
        room: AuraRoomData
    )

    func firstAction(
        room: AuraRoom
    )

    func showCreateChat()

    func roomSettings(
        isChannel: Bool,
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func chatMedia(
        room: AuraRoomData
    )

    func friendProfile(
        userId: String,
        roomId: String
    )

    func adminsView(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func chatMembersView(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func notifications(
        roomId: String
    )

    func popToRoot()

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    )

    func galleryPickerSheet(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    )

    func channelPatricipantsView(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>
    )

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
        room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    )

    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>,
        onSendPlace: @escaping (Place) -> Void
    )

    func messageReactions(
        isCurrentUser: Bool,
        isChannel: Bool,
        userRole: ChannelRole,
        onAction: @escaping GenericBlock<QuickActionCurrentUser>,
        onReaction: @escaping GenericBlock<String>
    )

    func onContactTap(
        contactInfo: ChatContactInfo
    )

    func onMapTap(
        place: Place
    )

    func onDocumentTap(
        name: String,
        fileUrl: URL
    )

    func onVideoTap(
        url: URL
    )

    func chatMenu(model: ActionsViewModel)

    func notSendedMessageMenu(
        event: RoomEvent,
        onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void
    )

    func showTransactionStatus(model: TransactionStatus)

    func transferCrypto(
        wallet: WalletInfo,
        receiverData: UserReceiverData?,
        onTransferCompletion: @escaping (TransactionResult) -> Void
    )
}
