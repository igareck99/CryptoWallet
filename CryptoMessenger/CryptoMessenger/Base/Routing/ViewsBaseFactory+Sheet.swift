import SwiftUI

extension ViewsBaseFactory {
    @ViewBuilder
    static func makeSheet(link: BaseSheetLink) -> some View {
        switch link {
        case let .transactionResult(model):
            TransactionResultAssembly.build(model: model)
        case let .addSeed(addSeedView):
            addSeedView()
        case let .chatRoomMenu(action, onCamera, onSendPhoto):
            ActionSheetViewAssembly.build(action, onCamera, onSendPhoto)
                .presentationDetents([.height(435)])
        case let .createChat(view, onDisappear):
            view().toolbar(.hidden, for: .navigationBar)
                .onDisappear {
                    onDisappear()
                }
                .anyView()
        case let .notifications(roomId):
            ChannelNotificationsAssembly.build(roomId)
        case let .galleryPicker(
            sourceType: sourceType,
            galleryContent: galleryContent,
            onSelectImage: onSelectImage,
            onSelectVideo: onSelectVideo
        ):
            GalleryPickerAssembly.build(
                sourceType: sourceType,
                galleryContent: galleryContent,
                onSelectImage: onSelectImage,
                onSelectVideo: onSelectVideo
            )
        case let .channelPatricipants(
            viewModel: viewModel,
            showParticipantsView: showParticipantsView
        ):
            ChannelParticipantsView(
                viewModel: viewModel,
                showParticipantsView: showParticipantsView
            )
        case let .chatActions(room, onSelect):
            ChatActionsAssembly.build(
                room,
                onSelect: onSelect
            ).anyView()
        case let .documentPicker(
            onCancel,
            onDocumentsPicked
        ):
            DocumentPickerAssembly.build(
                onCancel: onCancel,
                onDocumentsPicked: onDocumentsPicked
            )
        case let .locationPicker(place, sendLocation, onSendPlace):
            LocationPickerAssembly.build(
                place: place,
                sendLocation: sendLocation,
                onSendPlace: onSendPlace
            )
        case let .selectContacts(
            mode,
            chatData,
            contactsLimit,
            coordinator,
            onUsersSelected
        ):
            SelectContactAssembly.build(
                mode: mode,
                chatData: chatData,
                contactsLimit: contactsLimit,
                chatHistoryCoordinator: coordinator
            ) { value in
                onUsersSelected(value)
            }
        case let .contactInfo(contactInfo, delegate):
            ContactInfoViewAssembly.build(data: contactInfo, delegate: delegate)
        case let .map(place, delegate):
            AuraMapViewAssembly.build(place: place, delegate: delegate)
        case let .openOtherApp(place, showLocationTransition):
            AnotherAppTransitionViewAssembly.build(
                place: place,
                showLocationTransition: showLocationTransition
            )
        case let .file(fileName, fileUrl):
            PreviewControllerAssembly.build(
                url: fileUrl,
                fileName: fileName
            )
        case let .messageReactions(
            isCurrentUser: isCurrentUser,
            isChannel: isChannel,
            userRole: userRole,
            onAction: onAction,
            onReaction: onReaction
        ):
            RoomMessageMenuAssembly.build(
                isCurrentUser,
                isChannel,
                userRole,
                onAction,
                onReaction
            )
            .presentationDetents(
                [.height(CGFloat(QiuckMenyViewSize.size(isCurrentUser, isChannel, userRole)))]
            )
            .anyView()
        case let .sendingMessageMenu(event, onTapItem):
            NotSendedMessageMenuAssembly.build(event, onTapItem)
                .presentationDetents([.height(CGFloat(166))])
                .anyView()
        case .transactionStatus:
            TransactionStatusViewAssemlby.build().anyView()
        }
    }
}
