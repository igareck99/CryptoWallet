import SwiftUI

extension ViewsBaseFactory {
    @ViewBuilder
    static func makeSheet(link: BaseSheetLink) -> some View {
        switch link {
        case let .channelPatricipantsSheet(
            view: view,
            onDisappear: onDisappear
        ):
            view()
                .anyView()
        case let .countryCodeScene(delegate):
            CountryCodePicker(delegate: delegate)
        case let .transactionResult(model):
            TransactionResultAssembly.build(model: model)
        case let .addSeed(coordinator):
            GeneratePhraseViewAssembly.build(coordinator: coordinator)
        case let .chatRoomMenu(model):
            ActionSheetViewAssembly.build(model: model)
        case let .createChat(view, onDisappear):
            view()
            // TODO: Удалить это отсюда
                .toolbar(.hidden, for: .navigationBar)
                .onDisappear {
                    onDisappear()
                }
                .anyView()
        case let .notifications(roomId):
            ChannelNotificationsAssembly.build(roomId: roomId)
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
        case let .chatActions(room, onSelect):
            ChatActionsAssembly.build(
                room: room,
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
            messageType: messageType,
            hasReactions: hasReactions,
            hasAccessToWrite: hasAccessToWrite,
            isCurrentUser: isCurrentUser,
            isChannel: isChannel,
            userRole: userRole,
            onAction: onAction,
            onReaction: onReaction
        ):
            RoomMessageMenuAssembly.build(
                messageType: messageType,
                hasReactions: hasReactions,
                hasAccessToWrite: hasAccessToWrite,
                isCurrentUser: isCurrentUser,
                isChannel: isChannel,
                userRole: userRole,
                onAction: onAction,
                onReaction: onReaction
            )
        case let .sendingMessageMenu(event, onTapItem):
            NotSendedMessageMenuAssembly.build(event, onTapItem)
                // TODO: Удалить это отсюда
                .presentationDetents([.height(CGFloat(166))])
                .anyView()
        case let .transactionStatus(model):
                TransactionStatusViewAssemlby
                    .build(model: model).anyView()
        case let .settings(result):
            ProfileSettingsMenuAssembly.build(onSelect: result)
        case let .sheetPicker(sourceType):
            ProfileFeedImageAssembly.build(sourceType: sourceType)
        case let .channelPatricipants(viewModel: viewModel, showParticipantsView: showParticipantsView,
                                      coordinator: coordinator):
            ChannelParticipantsViewAssembly.build(viewModel,
                                                  showParticipantsView,
                                                  coordinator)
        }
    }
}
