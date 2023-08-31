import SwiftUI

// MARK: - ChatHistoryContentLink

enum ChatHistoryContentLink: Hashable, Identifiable {

    case chatRoom(room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)
    case chatHistrory
    case channelSettings(roomId: String,
                         isLeaveChannel: Binding<Bool>,
                         chatData: Binding<ChatData>,
                         saveData: Binding<Bool>,
                         coordinator: ChatHistoryFlowCoordinatorProtocol)
    case chatSettings(Binding<ChatData>, Binding<Bool>, Binding<Bool>, AuraRoom, ChatHistoryFlowCoordinatorProtocol)
    case chatMedia(room: AuraRoom)
    case friendProfile(contact: Contact)
    case adminList(chatData: Binding<ChatData>,
                   coordinator: ChatHistoryFlowCoordinatorProtocol)
    case chatMembers(chatData: Binding<ChatData>,
                     coordinator: ChatHistoryFlowCoordinatorProtocol)
    case galleryPicker(sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent,
                       onSelectImage: (UIImage?) -> Void,
                       onSelectVideo: (URL?) -> Void)
    case selectContact(
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

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatHistoryContentLink, rhs: ChatHistoryContentLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - ChatHistorySheetLink

enum ChatHistorySheetLink: Hashable, Identifiable {

    case notifications(_ roomId: String)
    case galleryPicker(sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent,
                       onSelectImage: (UIImage?) -> Void,
                       onSelectVideo: (URL?) -> Void)
    case channelPatricipants(viewModel: ChannelInfoViewModel,
                             showParticipantsView: Binding<Bool>)
    case createChat(_ view: any View)
    case chatActions(_ room: ChatActionsList, _ onSelect: GenericBlock<ChatActions>)
    case documentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: GenericBlock<[URL]>
    )

    case locationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>
    )

    case selectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        onUsersSelected: ([Contact]) -> Void
    )

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

// MARK: - ChatHistorySheetLink

enum ChatCreateSheetContentLink: Hashable, Identifiable {

    case selectContact(ChatCreateFlowCoordinatorProtocol)
    case createContact(ChatCreateFlowCoordinatorProtocol)
    case createChannel(ChatCreateFlowCoordinatorProtocol)
    case createGroupChat(ChatData, ChatCreateFlowCoordinatorProtocol)
    case createChat(coordinator: ChatCreateFlowCoordinatorProtocol)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatCreateSheetContentLink, rhs: ChatCreateSheetContentLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
