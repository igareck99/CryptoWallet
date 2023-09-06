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
