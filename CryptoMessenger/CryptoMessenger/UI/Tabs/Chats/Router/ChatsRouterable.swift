import Foundation
import SwiftUI

protocol ChatsRouterable: View {

    func writeToUser(_ room: AuraRoomData,
                     _ coordinator: ChatsCoordinatable)

    func navPathChild() -> Binding<NavigationPath>
    
    func previousScreen()

    func showVideo(url: URL)

    func showFile(name: String, fileUrl: URL)

    func showImageViewer(image: Image?, imageUrl: URL?)

    func showOpenOtherApp(
        place: Place,
        showLocationTransition: Binding<Bool>
    )

    func showMap(
        place: Place,
        delegate: AuraMapViewModelDelegate?
    )

    func showContactInfo(
        contactInfo: ChatContactInfo,
        delegate: ContactInfoViewModelDelegate
    )

    func chatRoom(
        room: AuraRoomData,
        roomOpenState: RoomOpenState,
        coordinator: ChatsCoordinatable
    )

    func routeToFirstAction(
        room: AuraRoom,
        coordinator: ChatsCoordinatable
    )

    func start()

    func chatMedia(room: AuraRoomData)

    func channelSettings(
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatsCoordinatable
    )

    func chatSettings(
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatsCoordinatable
    )

    func friendProfile(
        userId: String,
        roomId: String,
        coordinator: ChatsCoordinatable
    )

    func adminsView(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    )

    func chatMembersView(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    )

    func notifications(_ roomId: String)

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
        coordinator: ChatsCoordinatable,
        onUsersSelected: @escaping ([Contact]) -> Void
    )

    func channelPatricipantsView(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>
    )

    func dismissCurrentSheet()

    func routePath() -> Binding<NavigationPath>

    func presentedItem() -> Binding<BaseSheetLink?>

    func chatCreate(
        view: any View,
        onDisappear: @escaping () -> Void
    )
    
    func channelParticipantsViewCreate(
        view: any View,
        onDisappear: @escaping () -> Void
    )

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
        messageType: MessageType,
        hasReactions: Bool,
        hasAccessToWrite: Bool,
        isCurrentUser: Bool,
        isChannel: Bool,
        userRole: ChannelRole,
        onAction: @escaping GenericBlock<QuickActionCurrentUser>,
        onReaction: @escaping GenericBlock<String>
    )

    func chatMenu(model: ActionsViewModel)

    func notSendedMessageMenu(
        event: RoomEvent,
        onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void
    )

    func showTransactionStatus(model: TransactionStatus)
}
