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
    case galleryPicker(selectedImage: Binding<UIImage?>,
                       selectedVideo: Binding<URL?>,
                       sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent)

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

    case createChat(chatData: Binding<ChatData>,
                    coordinator: ChatCreateFlowCoordinatorProtocol)
    case notifications(_ roomId: String)
    case galleryPicker(selectedImage: Binding<UIImage?>,
                       selectedVideo: Binding<URL?>,
                       sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent)
    case channelPatricipants(viewModel: ChannelInfoViewModel,
                             showParticipantsView: Binding<Bool>)
    case selectContact(Binding<ChatData>, ChatCreateFlowCoordinatorProtocol)
    case createContact
    case createChannel(ChatCreateFlowCoordinatorProtocol)
    case createGroupChat(Binding<ChatData>, ChatCreateFlowCoordinatorProtocol)

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
