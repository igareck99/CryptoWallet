import SwiftUI

enum BaseContentLink: Hashable, Identifiable {

    // Auth
    case registration(delegate: RegistrationSceneDelegate?)
    case verification(delegate: VerificationSceneDelegate?)

    // Import seed
    case importKey(coordinator: ImportKeyCoordinatable)

    case addSeed(coordinator: PhraseGeneratable)

    case showPhrase(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    )

    // Chat history

    case chatRoom(
        room: AuraRoom,
        coordinator: ChatsCoordinatable
    )

    case chatHistory

    case channelSettings(
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    )

    case chatSettings(
        Binding<ChatData>,
        Binding<Bool>,
        AuraRoomData,
        ChatsCoordinatable
    )

    case chatMedia(
        room: AuraRoomData
    )

    case friendProfile(
        userId: String,
        roomId: String,
        coordinator: ChatsCoordinatable
    )

    case adminList(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    )

    case chatMembers(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    )

    case galleryPicker(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: (UIImage?) -> Void,
        onSelectVideo: (URL?) -> Void
    )

    case selectContacts(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatsCoordinatable,
        onUsersSelected: ([Contact]) -> Void
    )

    case documentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: GenericBlock<[URL]>
    )

    case newChat(
        room: AuraRoomData,
        openState: RoomOpenState,
        coordinator: ChatsCoordinatable
    )

    // Wallet

    case transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    )

    case transfer(
        wallet: WalletInfo,
        coordinator: TransferViewCoordinatable,
        receiverData: UserReceiverData?
    )

    case chooseReceiver(
        address: Binding<UserReceiverData>,
        coordinator: TransferViewCoordinatable
    )

    case facilityApprove(
        transaction: FacilityApproveModel,
        coordinator: FacilityApproveViewCoordinatable
    )

    case adressScanner(value: Binding<String>)

    case showTokenInfo(wallet: WalletInfo)

    // Chat create

    case selectContact(
        coordinator: ChatCreateFlowCoordinatorProtocol
    )

    case createContact(
        coordinator: ChatCreateFlowCoordinatorProtocol
    )

    case createChannel(
        coordinator: ChatCreateFlowCoordinatorProtocol,
        contacts: [SelectContact]
    )

    case createGroupChat(
        chatData: ChatData,
        coordinator: ChatCreateFlowCoordinatorProtocol,
        contacts: [Contact]
    )

    case createChat(
        coordinator: ChatCreateFlowCoordinatorProtocol
    )

    // Profile
    case socialList

    case imageEditor(
        isShowing: Binding<Bool>,
        image: Binding<UIImage?>,
        viewModel: ProfileViewModel
    )

    case profileDetail(
        _ coordinator: ProfileCoordinatable,
        _ image: Binding<UIImage?>
    )

    case security(
        _ coordinator: ProfileCoordinatable
    )

    case notifications(
        _ coordinator: ProfileCoordinatable
    )

    case aboutApp(
        _ coordinator: ProfileCoordinatable
    )

    case pinCode(PinCodeScreenType)

    case sessions(
        _ coordinator: ProfileCoordinatable
    )

    case blockList

    case countryCodeScene(delegate: CountryCodePickerDelegate)
    
    // ChannelParticipants
    
    case channelPatricipants(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>,
        coordinator: ChannelParticipantsFlowCoordinatorProtocol
    )
    
    case selectContactsParticipants(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int?,
        channelParticipantsCoordinator: ChannelParticipantsFlowCoordinatorProtocol,
        onUsersSelected: ([Contact]) -> Void
    )

    var id: String {
        String(describing: self)
    }

    static func == (lhs: BaseContentLink, rhs: BaseContentLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
