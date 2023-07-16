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
    func chatMembersView(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatHistoryFlowCoordinatorProtocol)
    func notifications(_ roomId: String)
    func popToRoot()
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent)
    func galleryPickerSheet(selectedImage: Binding<UIImage?>,
                            selectedVideo: Binding<URL?>,
                            sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent)
    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>)
    func dismissCurrentSheet()
}

// MARK: - ChatHistoryRouter

struct ChatHistoryRouter<Content: View, State: ChatHistoryCoordinatorBase>: View {

    // MARK: - Internal Properties
    
    @StateObject var state: State
    let content: () -> Content
    
    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
                    .sheet(item: $state.presentedItem, content: sheetContent)
            }
            .navigationDestination(
                for: ChatHistoryContentLink.self,
                destination: linkDestination
            )
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
        case let .chatMembers(chatData, coordinator):
            MembersViewAssembly.build(chatData: chatData,
                                      coordinator: coordinator)
        case let .galleryPicker(selectedImage: selectedImage,
                                selectedVideo: selectedVideo,
                                sourceType: sourceType,
                                galleryContent: galleryContent):
            GalleryPickerAssembly.build(selectedImage: selectedImage,
                                        selectedVideo: selectedVideo,
                                        sourceType: sourceType,
                                        galleryContent: galleryContent)
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
        case let .notifications(roomId):
            ChannelNotificationsAssembly.build(roomId)
        case let .galleryPicker(selectedImage: selectedImage,
                                selectedVideo: selectedVideo,
                                sourceType: sourceType,
                                galleryContent: galleryContent):
            GalleryPickerAssembly.build(selectedImage: selectedImage,
                                        selectedVideo: selectedVideo,
                                        sourceType: sourceType,
                                        galleryContent: galleryContent)
            .edgesIgnoringSafeArea(.all)
        case let .channelPatricipants(viewModel: viewModel, showParticipantsView: showParticipantsView):
            NavigationView {
                ChannelParticipantsView(viewModel: viewModel,
                                        showParticipantsView: showParticipantsView)
            }
        case let .notifications(roomId):
            ChannelNotificationsAssembly.build(roomId)
        case let .galleryPicker(selectedImage: selectedImage,
                                selectedVideo: selectedVideo,
                                sourceType: sourceType,
                                galleryContent: galleryContent):
            GalleryPickerAssembly.build(selectedImage: selectedImage,
                                        selectedVideo: selectedVideo,
                                        sourceType: sourceType,
                                        galleryContent: galleryContent)
            .edgesIgnoringSafeArea(.all)
        case let .channelPatricipants(viewModel: viewModel, showParticipantsView: showParticipantsView):
            NavigationView {
                ChannelParticipantsView(viewModel: viewModel,
                                        showParticipantsView: showParticipantsView)
            }
        }
    }
}

// MARK: - ChatHistoryRouter(ChatHistoryRouterable)

extension ChatHistoryRouter: ChatHistoryRouterable {
    func routeToFirstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(
            ChatHistoryContentLink.chatRoom(
                room: room,
                coordinator: coordinator
            )
        )
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
    
    func chatMembersView(_ chatData: Binding<ChatData>,
                         _ coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.chatMembers(chatData: chatData,
                                                             coordinator: coordinator))
    }
    
    func friendProfile(_ contact: Contact) {
        state.path.append(ChatHistoryContentLink.friendProfile(contact: contact))
    }

    func adminsView( _ chatData: Binding<ChatData>,
                     _ coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.adminList(chatData: chatData,
                                                           coordinator: coordinator))
    }
    
    func notifications(_ roomId: String) {
        state.presentedItem = .notifications(roomId)
    }
    
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent) {
        state.path.append(ChatHistoryContentLink.galleryPicker(selectedImage: selectedImage,
                                                               selectedVideo: selectedVideo, sourceType: sourceType, galleryContent: galleryContent))
    }
    
    func galleryPickerSheet(selectedImage: Binding<UIImage?>,
                            selectedVideo: Binding<URL?>,
                            sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent) {
        state.presentedItem = .galleryPicker(selectedImage: selectedImage,
                                             selectedVideo: selectedVideo,
                                             sourceType: sourceType,
                                             galleryContent: galleryContent)
    }
    
    func dismissCurrentSheet() {
        state.presentedItem = nil
    }
    
    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>) {
        state.presentedItem = .channelPatricipants(viewModel: viewModel,
                                                   showParticipantsView: showParticipantsView)
    }
}
