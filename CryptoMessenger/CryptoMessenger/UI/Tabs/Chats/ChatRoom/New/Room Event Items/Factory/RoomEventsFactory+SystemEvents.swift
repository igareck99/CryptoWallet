import Foundation

extension RoomEventsFactory {
    static func makeSystemEventItem(
        text: String,
        nextMessagePadding: CGFloat,
        onTap: @escaping () -> Void
    ) -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: text,
            textColor: .white,
            backColor: .chineseBlack04
        ) {
            debugPrint("systemEvent onTap")
            onTap()
        }
        return EventContainer(centralContent: systemEvent,
                              nextMessagePadding: nextMessagePadding) {
            
        } onTap: {
            
        }
    }
}
