import Foundation

extension RoomEventsFactory {
    static func makeSystemEventItem1() -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: "James присоединился к чату",
            textColor: .white,
            backColor: .royalOrange
        ) {
            debugPrint("systemEvent onTap")
        }
        return EventContainer(centralContent: systemEvent)
    }

    static func makeSystemEventItem2() -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: "Аватарка чату была изменена",
            textColor: .white,
            backColor: .royalOrange
        ) {
            debugPrint("systemEvent onTap")
        }
        return EventContainer(centralContent: systemEvent)
    }

    static func makeSystemEventItem3() -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: "Bob покинул чат",
            textColor: .white,
            backColor: .royalOrange
        ) {
            debugPrint("systemEvent onTap")
        }
        return EventContainer(centralContent: systemEvent)
    }

    static func makeSystemEventItem4() -> any ViewGeneratable {
        let systemEvent = SystemEvent(
            text: "Чат создан",
            textColor: .white,
            backColor: .royalOrange
        ) {
            debugPrint("systemEvent onTap")
        }
        return EventContainer(centralContent: systemEvent)
    }
}
