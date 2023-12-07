import Foundation

// MARK: - Call Items

extension RoomEventsFactory {
    static func makeRightCallItem() -> any ViewGeneratable {
        let callItem = CallItem(
            subtitle: "16:12, 12 секунд",
            type: .incomeAnswered
        ) {
            debugPrint("onTap CallItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .right,
            content: callItem
        )

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer
        )
    }

    static func makeLeftCallItem() -> any ViewGeneratable {
        let callItem = CallItem(
            subtitle: "16:12, 12 секунд",
            type: .outcomeUnanswered
        ) {
            debugPrint("onTap CallItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .left,
            content: callItem
        )

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel()
        )
    }

    static func makeEqualRightCallItem() -> any ViewGeneratable {
        let callItem = CallItem(
            subtitle: "16:12, 12 секунд",
            type: .outcomeAnswered
        ) {
            debugPrint("onTap CallItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .equal,
            content: callItem
        )

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer
        )
    }

    static func makeEqualLeftCallItem() -> any ViewGeneratable {
        let callItem = CallItem(
            subtitle: "16:12, 12 секунд",
            type: .incomeUnanswered
        ) {
            debugPrint("onTap CallItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .equal,
            content: callItem
        )

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel()
        )
    }
}
