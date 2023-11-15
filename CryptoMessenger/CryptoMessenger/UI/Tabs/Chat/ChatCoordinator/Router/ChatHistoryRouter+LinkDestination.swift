import Foundation
import SwiftUI

extension ChatHistoryRouter {
    
    @ViewBuilder
    func linkDestination(link: ChatHistoryContentLink) -> some View {
        switch link {
            case let .chatRoom(room, coordinator):
                ChatRoomAssembly.build(room: room,
                                       coordinator: coordinator)
            case let .chatSettings(chatData, isLeaveChannel, room, coordinator):
                ChatSettingsAssembly.build(room, coordinator)
            case let .channelSettings(room, isLeaveChannel, chatData, coordinator):
                ChannelInfoAssembly.build(room: room,
                                      coordinator: coordinator,
                                      isLeaveChannel: isLeaveChannel,
                                      chatData: chatData)
            case let .chatMedia(room):
                ChannelMediaAssembly.build(room: room)
            case let .friendProfile(contact):
                FriendProfileAssembly.build(userId: contact)
            case let .adminList(chatData, coordinator):
                AdminsViewAssembly.build(chatData: chatData,
                                         coordinator: coordinator)
            case let .chatMembers(chatData, coordinator):
                MembersViewAssembly.build(chatData: chatData,
                                          coordinator: coordinator)
            case let .galleryPicker(sourceType: sourceType,
                                    galleryContent: galleryContent,
                                    onSelectImage: onSelectImage,
                                    onSelectVideo: onSelectVideo):
                GalleryPickerAssembly.build(sourceType: sourceType,
                                            galleryContent: galleryContent,
                                            onSelectImage: onSelectImage,
                                            onSelectVideo: onSelectVideo)
            case let .documentPicker(
                onCancel,
                onDocumentsPicked
            ):
                DocumentPickerAssembly.build(
                    onCancel: onCancel,
                    onDocumentsPicked: onDocumentsPicked
                )
            case let .selectContact(
                mode,
                chatData,
                contactsLimit,
                coordinator,
                onUsersSelected
            ):
                SelectContactAssembly.build(
                    mode: mode,
                    chatData: chatData,
                    contactsLimit: contactsLimit, chatHistoryCoordinator: coordinator, onUsersSelected: { value in
                        onUsersSelected(value)
                    }
                )
            case let .newChat(room: room, coordinator: coordinator):
                ChatViewAssembly.build(room, coordinator)
            default:
                EmptyView()
        }
    }
}
