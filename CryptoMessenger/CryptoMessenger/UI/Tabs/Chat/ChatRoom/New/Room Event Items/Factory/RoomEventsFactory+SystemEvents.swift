import Foundation

extension RoomEventsFactory {
    static func makeSystemEventItem() -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: "James присоединился к чату",
            textColor: .white,
            backColor: .royalOrange
        ) {
            debugPrint("systemEvent onTap")
        }
        return EventContainer(centralContent: systemEvent) { }
    }
}
