import Foundation
import SwiftUI

// MARK: - ChatHistoryRouterable

extension ChatHistoryRouter: ChatHistoryRouterable {

    func showContactInfo(
        contactInfo: ChatContactInfo,
        delegate: ContactInfoViewModelDelegate
    ) {
        state.presentedItem = .contactInfo(
            contactInfo: contactInfo,
            delegate: delegate
        )
    }

    func showMap(
        place: Place,
        delegate: AuraMapViewModelDelegate?
    ) {
        state.presentedItem = .map(
            place: place,
            delegate: delegate
        )
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

    func routeToFirstAction(
        room: AuraRoom,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.chatRoom(
                room: room,
                coordinator: coordinator
            )
        )
    }

    func start() {
        state.path.append(BaseContentLink.chatHistory)
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
        state.coverItem = nil
    }

    func chatSettings(
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.chatSettings(
                chatData,
                isLeaveChannel,
                room,
                coordinator
            )
        )
    }

    func channelSettings(
        chatData: Binding<ChatData>,
        room: AuraRoomData,
        isLeaveChannel: Binding<Bool>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.channelSettings(
                room: room,
                isLeaveChannel: isLeaveChannel,
                chatData: chatData,
                coordinator: coordinator
            )
        )
    }

    func chatMedia(room: AuraRoomData) {
        state.path.append(BaseContentLink.chatMedia(room: room))
    }

    func chatMembersView(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.chatMembers(
                chatData: chatData,
                coordinator: coordinator
            )
        )
    }

    func friendProfile(
        userId: String,
        roomId: String,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.friendProfile(
                userId: userId,
                roomId: roomId,
                coordinator: coordinator
            )
        )
    }

    func adminsView(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.adminList(
                chatData: chatData,
                coordinator: coordinator
            )
        )
    }

    func notifications(_ roomId: String) {
        state.presentedItem = .notifications(
            roomId: roomId
        )
    }

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) {
        state.path.append(
            BaseContentLink.galleryPicker(
                sourceType: sourceType,
                galleryContent: galleryContent,
                onSelectImage: onSelectImage,
                onSelectVideo: onSelectVideo
            )
        )
    }

    func showDocumentPicker(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        state.path.append(
            BaseContentLink.documentPicker(
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

    func galleryPickerSheet(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) {
        state.presentedItem = .galleryPicker(
            sourceType: sourceType,
            galleryContent: galleryContent,
            onSelectImage: onSelectImage,
            onSelectVideo: onSelectVideo
        )
    }

    func showSelectContact(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        onUsersSelected: @escaping ([Contact]) -> Void
    ) {
        state.presentedItem = .selectContacts(
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

    func channelPatricipantsView(
        viewModel: ChannelInfoViewModel,
        showParticipantsView: Binding<Bool>
    ) {
        state.presentedItem = .channelPatricipants(
            viewModel: viewModel,
            showParticipantsView: showParticipantsView
        )
    }

    func routePath() -> Binding<NavigationPath> {
        $state.path
    }

    func presentedItem() -> Binding<BaseSheetLink?> {
        $state.presentedItem
    }

    func chatCreate(
        view: any View,
        onDisappear: @escaping () -> Void
    ) {
        state.presentedItem = .createChat(
            view: { view },
            onDisappear: onDisappear
        )
    }

    func chatActions(
        room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    ) {
        state.presentedItem = .chatActions(
            room: room,
            onSelect: onSelect
        )
    }

    func presentLocationPicker(
        place: Binding<Place?>,
        sendLocation: Binding<Bool>,
        onSendPlace: @escaping (Place) -> Void
    ) {
        state.presentedItem = .locationPicker(
            place: place,
            sendLocation: sendLocation,
            onSendPlace: onSendPlace
        )
    }

    func chatRoom(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) {
        state.path.append(
            BaseContentLink.newChat(
                room: room,
                coordinator: coordinator
            )
        )
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

    func messageReactions(
        isCurrentUser: Bool,
        isChannel: Bool,
        userRole: ChannelRole,
        onAction: @escaping GenericBlock<QuickActionCurrentUser>,
        onReaction: @escaping GenericBlock<String>
    ) {
        state.presentedItem = .messageReactions(
            isCurrentUser: isCurrentUser,
            isChannel: isChannel,
            userRole: userRole,
            onAction: onAction,
            onReaction: onReaction
        )
    }

    func chatMenu(model: ActionsViewModel) {
        state.presentedItem = .chatRoomMenu(model: model)
    }

    func notSendedMessageMenu(
        event: RoomEvent,
        onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void
    ) {
        state.presentedItem = .sendingMessageMenu(event: event, onTapItem: onTapItem)
    }

    func showTransactionStatus(model: TransactionStatus) {
        state.presentedItem = .transactionStatus(model: model)
    }
}
