import Foundation
import SwiftUI

extension ChatHistoryRouter {

    @ViewBuilder
    func sheetContent(item: ChatHistorySheetLink) -> some View {
        switch item {
        case let .createChat(view):
            view.toolbar(.hidden, for: .navigationBar).anyView()
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
                onSelect: onSelect,
                viewHeight: { value in
                    state.sheetHeight = value
                })
            .presentationDetents([.large, .height(state.sheetHeight)]).anyView()
        case let .documentPicker(
            onCancel,
            onDocumentsPicked
        ):
            DocumentPickerAssembly.build(
                onCancel: onCancel,
                onDocumentsPicked: onDocumentsPicked
            )
        case let .locationPicker(place, sendLocation):
            LocationPickerAssembly.build(
                place: place,
                sendLocation: sendLocation
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
        case let .messageReactions(isCurrentUser: isCurrentUser,
                                   isChannel: isChannel,
                                   userRole: userRole,
                                   onAction: onAction,
                                   onReaction: onReaction):
            RoomMessageMenuAssembly.build(isCurrentUser,
                                          isChannel,
                                          userRole,
                                          onAction,
                                          onReaction)
            .presentationDetents([.height(CGFloat(QiuckMenyViewSize.size(isCurrentUser, isChannel, userRole)))])
            .anyView()
        }
    }
}
