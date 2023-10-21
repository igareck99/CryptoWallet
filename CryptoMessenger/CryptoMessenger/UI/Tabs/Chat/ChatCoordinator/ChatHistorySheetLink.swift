import SwiftUI

enum ChatHistorySheetLink: Hashable, Identifiable {

    case notifications(_ roomId: String)
    case galleryPicker(sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent,
                       onSelectImage: (UIImage?) -> Void,
                       onSelectVideo: (URL?) -> Void)
    case channelPatricipants(viewModel: ChannelInfoViewModel,
                             showParticipantsView: Binding<Bool>)
    case createChat(_ view: any View, _ onDisappear: () -> Void)
    case chatActions(_ room: ChatActionsList, _ onSelect: GenericBlock<ChatActions>)
    case documentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: GenericBlock<[URL]>
    )

    case locationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>,
        onSendPlace: (Place) -> Void
    )

    case selectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        onUsersSelected: ([Contact]) -> Void
    )

    case contactInfo(
        contactInfo: ChatContactInfo,
        delegate: ContactInfoViewModelDelegate
    )

    case map(
        place: Place,
        delegate: AuraMapViewModelDelegate?
    )

    case openOtherApp(
        place: Place,
        showLocationTransition: Binding<Bool>
    )

    case file(name: String, fileUrl: URL)

    case messageReactions(isCurrentUser: Bool,
                          isChannel: Bool,
                          userRole: ChannelRole,
                          onAction: GenericBlock<QuickActionCurrentUser>,
                          onReaction: GenericBlock<String>)
    
    case chatRoomMenu(_ tappedAction: (AttachAction) -> Void,
                      _ onCamera: () -> Void,
                      _ onSendPhoto: (UIImage) -> Void)
    case sendingMessageMenu(_ event: RoomEvent,
                            _ onTapItem: (NotSendedMessage, RoomEvent) -> Void)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatHistorySheetLink, rhs: ChatHistorySheetLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
