import Foundation

extension RoomEventsFactory {
    static func makeDocumentItem(
        event: RoomEvent,
        name: String?,
        url: URL?
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
        )
        let items: [ReactionNewEvent] = []
        let viewModel = ReactionsNewViewModel(width: calculateWidth("", items.count),
                                              views: items, backgroundColor: .brilliantAzure)
        let docItem = DocumentItem(
            imageName: "paperclip.circle.fill",
            title: name ?? "", // "Экран для Aura.docx",
            subtitle: "2.8MB",
            url: .mock,
            reactionsGrid: viewModel, // reactionsGrid,
            eventData: eventData
        ) {
            debugPrint("onTap DocumentItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: docItem
        )

        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel()
        )
    }
}
