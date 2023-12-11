import Foundation
import SwiftUI

protocol ChatHistoryRouterable: View {

    func chatRoom(_ room: AuraRoomData, _ coordinator: ChatHistoryFlowCoordinatorProtocol)

    func routeToFirstAction(_ room: AuraRoom, coordinator: ChatHistoryFlowCoordinatorProtocol)

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
    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void)
    func galleryPickerSheet(sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent,
                            onSelectImage: @escaping (UIImage?) -> Void,
                            onSelectVideo: @escaping (URL?) -> Void)

    func showDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    )

    func presentDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    )

    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int?,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        onUsersSelected: @escaping ([Contact]) -> Void
    )

    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>)
    func dismissCurrentSheet()
    func routePath() -> Binding<NavigationPath>
    func presentedItem() -> Binding<ChatHistorySheetLink?>
    func chatCreate(_ view: any View)
    func chatActions(
        _ room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    )
    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>
    )
    func messageReactions(_ isCurrentUser: Bool,
                          _ isChannel: Bool,
                          _ userRole: ChannelRole,
                          _ onAction: @escaping GenericBlock<QuickActionCurrentUser>,
                          _ onReaction: @escaping GenericBlock<String>) 
}

// MARK: - ChatHistoryRouter

struct ChatHistoryRouter<Content: View, State: ChatHistoryCoordinatorBase>: View {

    // MARK: - Internal Properties

    @ObservedObject var state: State
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
            ).anyView()
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
            .anyView()
        case let .newChat(room: room, coordinator: coordinator):
            ChatViewAssembly.build(room, coordinator)
        default:
            EmptyView()
        }
    }

    private func sheetContent(item: ChatHistorySheetLink) -> AnyView {
        switch item {
            case let .createChat(view):
                return view.toolbar(.hidden,
                                    for: .navigationBar)
                .anyView()
            case let .notifications(roomId):
                return ChannelNotificationsAssembly.build(roomId).anyView()
            case let .galleryPicker(sourceType: sourceType,
                                    galleryContent: galleryContent,
                                    onSelectImage: onSelectImage,
                                    onSelectVideo: onSelectVideo):
                return GalleryPickerAssembly.build(sourceType: sourceType,
                                                   galleryContent: galleryContent,
                                                   onSelectImage: onSelectImage,
                                                   onSelectVideo: onSelectVideo).anyView()
            case let .channelPatricipants(viewModel: viewModel, showParticipantsView: showParticipantsView):
                return ChannelParticipantsView(viewModel: viewModel,
                                               showParticipantsView: showParticipantsView).anyView()
            case let .chatActions(room, onSelect):
                return ChatActionsAssembly.build(room, onSelect: onSelect, viewHeight: { value in
                    state.sheetHeight = value
                })
                .presentationDetents([.large, .height(state.sheetHeight)])
                .anyView()
                
            case let .documentPicker(
                onCancel,
                onDocumentsPicked
            ):
                return DocumentPickerAssembly.build(
                    onCancel: onCancel,
                    onDocumentsPicked: onDocumentsPicked
                ).anyView()
            case let .locationPicker(place, sendLocation):
                return LocationPickerAssembly.build(
                    place: place,
                    sendLocation: sendLocation
                ).anyView()
            case let .selectContact(
                mode,
                chatData,
                contactsLimit,
                coordinator,
                onUsersSelected
            ):
                return SelectContactAssembly.build(
                    mode: mode,
                    chatData: chatData,
                    contactsLimit: contactsLimit,
                    chatHistoryCoordinator: coordinator, onUsersSelected: { value in
                        onUsersSelected(value)
                    }
                )
                .anyView()
        case let .messageReactions(isCurrentUser: isCurrentUser,
                                   isChannel: isChannel,
                                   userRole: userRole,
                                   onAction: onAction,
                                   onReaction: onReaction):
            return RoomMessageMenuAssembly.build(isCurrentUser,
                                                 isChannel,
                                                 userRole,
                                                 onAction,
                                                 onReaction)
            .presentationDetents([.height(CGFloat(QiuckMenyViewSize.size(isCurrentUser, isChannel, userRole)))])
            .anyView()
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

    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void) {
        state.path.append(ChatHistoryContentLink.galleryPicker(sourceType: sourceType,
                                                               galleryContent: galleryContent,
                                                               onSelectImage: onSelectImage,
                                                               onSelectVideo: onSelectVideo))
    }

    func showDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        state.path.append(
            ChatHistoryContentLink.documentPicker(
                onCancel: onCancel,
                onDocumentsPicked: onDocumentsPicked
            )
        )
    }

    func presentDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        state.presentedItem = .documentPicker(
            onCancel: onCancel,
            onDocumentsPicked: onDocumentsPicked
        )
    }

    func galleryPickerSheet(sourceType: UIImagePickerController.SourceType,
                            galleryContent: GalleryPickerContent,
                            onSelectImage: @escaping (UIImage?) -> Void,
                            onSelectVideo: @escaping (URL?) -> Void) {
        state.presentedItem = .galleryPicker(sourceType: sourceType,
                                             galleryContent: galleryContent,
                                             onSelectImage: onSelectImage,
                                             onSelectVideo: onSelectVideo)
    }
    
    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        onUsersSelected: @escaping ([Contact]) -> Void
    ) {
        state.presentedItem = .selectContact(
            mode: mode,
            chatData: chatData,
            contactsLimit: contactsLimit,
            coordinator: coordinator,
            onUsersSelected: onUsersSelected
        )
    }

    func dismissCurrentSheet() {
        state.presentedItem = nil
    }

    func channelPatricipantsView(_ viewModel: ChannelInfoViewModel,
                                 showParticipantsView: Binding<Bool>) {
        state.presentedItem = .channelPatricipants(viewModel: viewModel,
                                                   showParticipantsView: showParticipantsView)
    }

    func routePath() -> Binding<NavigationPath> {
        $state.path
    }

    func presentedItem() -> Binding<ChatHistorySheetLink?> {
        $state.presentedItem
    }

    func chatCreate(_ view: any View) {
        state.presentedItem = .createChat(view)
    }

    func chatActions(_ room: ChatActionsList, onSelect: @escaping GenericBlock<ChatActions>) {
        state.presentedItem = .chatActions(room, onSelect)
    }

    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>
    ) {
        state.presentedItem = .locationPicker(
            place: place,
            sendLocation: sendLocation
        )
    }
    
    func chatRoom(_ room: AuraRoomData, _ coordinator: ChatHistoryFlowCoordinatorProtocol) {
        state.path.append(ChatHistoryContentLink.newChat(room: room,
                                                         coordinator: coordinator))
    }
    
    func messageReactions(_ isCurrentUser: Bool,
                          _ isChannel: Bool,
                          _ userRole: ChannelRole,
                          _ onAction: @escaping GenericBlock<QuickActionCurrentUser>,
                          _ onReaction: @escaping GenericBlock<String>) {
        state.presentedItem = .messageReactions(isCurrentUser: isCurrentUser,
                                                isChannel: isChannel,
                                                userRole: userRole,
                                                onAction: onAction,
                                                onReaction: onReaction)
    }
}