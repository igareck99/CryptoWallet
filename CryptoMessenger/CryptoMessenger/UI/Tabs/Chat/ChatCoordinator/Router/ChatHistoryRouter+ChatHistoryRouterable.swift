import Foundation
import SwiftUI

// MARK: - ChatHistoryRouterable

extension ChatHistoryRouter: ChatHistoryRouterable {

    func showContactInfo(contactInfo: ChatContactInfo, delegate: ContactInfoViewModelDelegate) {
        state.presentedItem = .contactInfo(contactInfo: contactInfo, delegate: delegate)
    }

    func showMap(place: Place, delegate: AuraMapViewModelDelegate?) {
        state.presentedItem = .map(place: place, delegate: delegate)
    }

    func showOpenOtherApp(
        place: Place,
        showLocationTransition: Binding<Bool>
    ) {
        state.presentedItem = .openOtherApp(
            place: place,
            showLocationTransition: showLocationTransition
        )
    }

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

    func showImageViewer(imageUrl: URL?) {
        state.coverItem = .imageViewer(imageUrl: imageUrl)
    }

    func showFile(name: String, fileUrl: URL) {
        state.presentedItem = .file(name: name, fileUrl: fileUrl)
    }

    func showVideo(url: URL) {
        state.coverItem = .video(url: url)
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
