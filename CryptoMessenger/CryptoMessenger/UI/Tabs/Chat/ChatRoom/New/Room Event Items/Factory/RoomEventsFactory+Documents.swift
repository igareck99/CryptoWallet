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
        let docItem = DocumentItem(
            imageName: "paperclip.circle.fill",
            title: name ?? "", // "Экран для Aura.docx",
            subtitle: "2.8MB",
            url: .mock,
            reactionsGrid: ZeroViewModel(), // reactionsGrid,
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
