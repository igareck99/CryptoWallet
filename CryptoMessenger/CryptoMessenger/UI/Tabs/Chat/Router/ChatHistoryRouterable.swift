import Foundation
import SwiftUI

protocol ChatHistoryRouterable: View {

    func showVideo(url: URL)

    func showFile(name: String, fileUrl: URL)

    func showImageViewer(imageUrl: URL?)

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
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func routeToFirstAction(
        room: AuraRoom,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func start()

    func chatMedia(room: AuraRoomData)

    func channelSettings(
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func chatSettings(
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func friendProfile(
        userId: String,
        roomId: String,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func adminsView(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func chatMembersView(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
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
        coordinator: ChatHistoryFlowCoordinatorProtocol,
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

    func chatMenu(
        tappedAction: @escaping (AttachAction) -> Void,
        onCamera: @escaping () -> Void,
        onSendPhoto: @escaping (UIImage) -> Void
    )

    func notSendedMessageMenu(
        event: RoomEvent,
        onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void
    )

    func showTransactionStatus(model: TransactionStatus)
}
