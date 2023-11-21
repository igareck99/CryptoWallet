import SwiftUI

typealias AddSeedViewType = AddSeedRouter<AddSeedView<AddSeedViewModel>, AddSeedState, WalletRouterState>
typealias AddSeedViewBuilder = () -> (AddSeedRouter<GeneratePhraseView, AddSeedState, WalletRouterState>)?

enum BaseContentLink: Hashable, Identifiable {

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
        coordinator: TransferViewCoordinatable
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
