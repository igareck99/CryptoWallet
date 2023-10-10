import Foundation

extension RoomEventsFactory {
    static func makeSystemEventItem(
        text: String,
        onTap: @escaping () -> Void
    ) -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: text,
            textColor: .white,
            backColor: .royalOrange
        ) {
            debugPrint("systemEvent onTap")
            onTap()
        }
        return EventContainer(centralContent: systemEvent) { }
    }
}