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
        _ room: AuraRoomData,
        _ coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func routeToFirstAction(
        _ room: AuraRoom,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func start()

    func chatMedia(_ room: AuraRoom)

    func channelSettings(
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>,
        room: AuraRoom,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func chatSettings(
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>,
        room: AuraRoom,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func friendProfile(_ contact: Contact)

    func adminsView(
        _ chatData: Binding<ChatData>,
        _ coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    func chatMembersView(
        _ chatData: Binding<ChatData>,
        _ coordinator: ChatHistoryFlowCoordinatorProtocol
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
        _ viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>
    )

    func dismissCurrentSheet()

    func routePath() -> Binding<NavigationPath>

    func presentedItem() -> Binding<ChatHistorySheetLink?>

    func chatCreate(_ view: any View)

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
    
    func chatMenu(_ tappedAction: @escaping (AttachAction) -> Void,
                  _ onCamera: @escaping () -> Void,
                  _ onSendPhoto: @escaping (UIImage) -> Void)
}
