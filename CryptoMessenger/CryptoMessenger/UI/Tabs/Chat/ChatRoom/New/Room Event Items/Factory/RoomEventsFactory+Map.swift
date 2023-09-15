import SwiftUI

extension RoomEventsFactory {
    static func makeMapItem(
        event: RoomEvent,
        lat: Double,
        lon: Double
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event)
        let viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.map.size,  reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)

        let mapEventItem = MapEvent(
            place: Place(name: "Name", latitude: lat, longitude: lon),
            eventData: eventData
        ) {
            debugPrint("onTap MapEvent")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .diamond,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: mapEventItem
        )
        
        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                bottomContent: viewModel
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            bottomContent: viewModel
        )
    }
}
