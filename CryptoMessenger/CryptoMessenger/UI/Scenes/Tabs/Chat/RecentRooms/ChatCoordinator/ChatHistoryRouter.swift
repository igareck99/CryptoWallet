import Foundation
import SwiftUI

protocol ChatHistoryRouterable {

    func routeToFirstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)

    func routeToCreateChat(_ chatData: Binding<ChatData>)

    func start()

    func chatMedia(_ room: AuraRoom)

    func channelSettings(chatData: Binding<ChatData>,
                         saveData: Binding<Bool>,
                         room: AuraRoom,
                         isLeaveChannel: Binding<Bool>,
                         coordinator: ChatHistoryFlowCoordinatorProtocol)

    func chatSettings(chatData: Binding<ChatData>,
                      saveData: Binding<Bool>,
                      room: AuraRoom,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol)

    func friendProfile(_ contact: Contact)
    
    func adminsView( _ chatData: Binding<ChatData>,
                     _ coordinator: ChatHistoryFlowCoordinatorProtocol)
}

// MARK: - ChatHistoryRouter

struct ChatHistoryRouter<Content: View>: View {

    // MARK: - Internal Properties

    @ObservedObject var state = ChatHistoryFlowState()

    let content: () -> Content

    init(
        content: @escaping () -> Content
    ) {
        self.content = content
    }

    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
            }
            .navigationDestination(for: ChatHistoryContentLink.self,
                                   destination: linkDestination)
            .sheet(item: $state.presentedItem, content: sheetContent)
        }
    }

    @ViewBuilder
    private func linkDestination(link: ChatHistoryContentLink) -> some View {
        switch link {
        case let .chatRoom(room, coordinator):
            ChatRoomAssembly.build(room: room,
                                   coordinator: coordinator)
        case let .chatSettings(chatData, saveData, isLeaveChannel, room, coordinator):
            SettingsAssembly.build(chatData: chatData,
                                   isLeaveRoom: isLeaveChannel,
                                   saveData: saveData, room: room, coordinator: coordinator)
        case let .channelSettings(roomId, isLeaveChannel, chatData, saveData, coordinator):
            ChannelInfoAssembly.build(roomId: roomId,
                                      coordinator: coordinator,
                                      isLeaveChannel: isLeaveChannel,
                                      chatData: chatData,
                                      saveData: saveData)
        case let .chatMedia(room):
            ChannelMediaAssembly.build(room: room)
        case let .friendProfile(contact):
            FriendProfileAssembly.build(userId: contact)
        case let .adminList(chatData, coordinator):
            AdminsViewAssembly.build(chatData: chatData,
                                     coordinator: coordinator)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func sheetContent(item: ChatHistorySheetLink) -> some View {
        switch item {
        case let .createChat(chatData):
            ChatCreateAssembly.build(chatData, onCoordinatorEnd: {
                popToRoot()
            })
        default:
            EmptyView()
        }
    }
}

extension ChatHistoryRouter: ChatHistoryRouterable {
    func routeToFirstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.chatRoom(room: room,
                                                          coordinator: coordinator))
    }

    func routeToCreateChat(_ chatData: Binding<ChatData>) {
        state.presentedItem = .createChat(chatData: chatData)
    }

    func start() {
        state.path.append(ChatHistoryContentLink.chatHistrory)
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
        state.coverItem = nil
        state.selectedLink = nil
    }

    func chatSettings(chatData: Binding<ChatData>,
                      saveData: Binding<Bool>,
                      room: AuraRoom,
                      isLeaveChannel: Binding<Bool>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.chatSettings(chatData, saveData, isLeaveChannel, room, coordinator))
    }

    func channelSettings(chatData: Binding<ChatData>,
                         saveData: Binding<Bool>,
                         room: AuraRoom,
                         isLeaveChannel: Binding<Bool>,
                         coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.channelSettings(roomId: room.room.roomId,
                                                                 isLeaveChannel: saveData,
                                                                 chatData: chatData,
                                                                 saveData: isLeaveChannel, coordinator: coordinator))
    }

    func chatMedia(_ room: AuraRoom) {
        state.path.append(ChatHistoryContentLink.chatMedia(room: room))
    }

    func friendProfile(_ contact: Contact) {
        state.path.append(ChatHistoryContentLink.friendProfile(contact: contact))
    }
    
    func adminsView( _ chatData: Binding<ChatData>,
                     _ coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.adminList(chatData: chatData, coordinator: coordinator))
    }
}
