import Foundation

extension RoomEventsFactory {

    static func makeCallItem(event: RoomEvent) -> any ViewGeneratable {

        let callItem = CallItem(
            subtitle: event.shortDate,
            type: event.isFromCurrentUser ? .outcomeAnswered : .incomeAnswered
        ) {
            debugPrint("onTap CallItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: callItem
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

extension RoomEventsFactory {
    static let sources = ChatRoomResources.self
    private enum Constants {
        static let rejectCallKey = "m.call.reject"
        static let hangupCallKey = "m.call.hangup"
        static let reasonKey = "reason"
        static let userHangupReasonKey = "user_hangup"
        static let inviteTimeoutReasonKey = "invite_timeout"
    }

    private static func textForCallEventReason(
        eventType: String,
        content: [String: Any]
    ) -> String {

        if eventType == Constants.rejectCallKey {
            return sources.callDeclined
        }

        if eventType == Constants.hangupCallKey,
           let reason = content[Constants.reasonKey] as? String,
           reason == Constants.inviteTimeoutReasonKey {
            return sources.callMissed
        }
        return sources.callFinished
    }
}
