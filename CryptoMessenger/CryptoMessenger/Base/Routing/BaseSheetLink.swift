import SwiftUI

enum BaseSheetLink: Hashable, Identifiable {

    // Auth
    case countryCodeScene(delegate: CountryCodePickerDelegate)

    // Wallet
    case transactionResult(model: TransactionResult)
    case addSeed(coordinator: PhraseGeneratable)

    // Chat history
    case notifications(
        roomId: String
    )
    case galleryPicker(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: (UIImage?) -> Void,
        onSelectVideo: (URL?) -> Void
    )
    case channelPatricipants(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>
    )
    case createChat(
        view: () -> any View,
        onDisappear: () -> Void
    )
    case chatActions(
        room: ChatActionsList,
        onSelect: GenericBlock<ChatActions>
    )
    case documentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: GenericBlock<[URL]>
    )

    case locationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>,
        onSendPlace: (Place) -> Void
    )

    case selectContacts(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatsCoordinatable,
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

    case messageReactions(
        isCurrentUser: Bool,
        isChannel: Bool,
        userRole: ChannelRole,
        onAction: GenericBlock<QuickActionCurrentUser>,
        onReaction: GenericBlock<String>
    )

    case chatRoomMenu(model: ActionsViewModel)

    case sendingMessageMenu(
        event: RoomEvent,
        onTapItem: (NotSendedMessage, RoomEvent) -> Void
    )

    // Transaction

    case transactionStatus(model: TransactionStatus)

    // Profile
    case settings(GenericBlock<ProfileSettingsMenu>)
    case sheetPicker((UIImagePickerController.SourceType) -> Void)

    var id: String {
        String(reflecting: self)
    }

    static func == (lhs: BaseSheetLink, rhs: BaseSheetLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
