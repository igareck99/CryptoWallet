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
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    case chatHistory

    case channelSettings(
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    case chatSettings(
        Binding<ChatData>,
        Binding<Bool>,
        AuraRoomData,
        ChatHistoryFlowCoordinatorProtocol
    )

    case chatMedia(
        room: AuraRoomData
    )

    case friendProfile(
        userId: String,
        roomId: String,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    case adminList(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    )

    case chatMembers(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
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
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        onUsersSelected: ([Contact]) -> Void
    )

    case documentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: GenericBlock<[URL]>
    )

    case newChat(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol
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
        _ coordinator: ProfileFlowCoordinatorProtocol,
        _ image: Binding<UIImage?>
    )

    case security(
        _ coordinator: ProfileFlowCoordinatorProtocol
    )

    case notifications(
        _ coordinator: ProfileFlowCoordinatorProtocol
    )

    case aboutApp(
        _ coordinator: ProfileFlowCoordinatorProtocol
    )

    case pinCode(PinCodeScreenType)

    case sessions(
        _ coordinator: ProfileFlowCoordinatorProtocol
    )

    case blockList

    case countryCodeScene(delegate: CountryCodePickerDelegate)

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
