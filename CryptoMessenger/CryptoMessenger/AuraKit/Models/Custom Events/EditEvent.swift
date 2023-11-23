import Foundation

// MARK: - EditEvent

struct EditEvent {

    // MARK: - Internal Properties

    let eventId: String
    let text: String
}

// MARK: - EditEvent (CustomEvent)

extension EditEvent: CustomEvent {

    // MARK: - Internal Methods

    func encodeContent() -> [String: Any] {
        [
            "body": "*" + text,
            "m.new_content": [
                "body": text,
                "msgtype": kMXMessageTypeText
            ],
            "m.relates_to": [
                "event_id": eventId,
                "rel_type": MXEventRelationTypeReplace
            ],
            "msgtype": kMXMessageTypeText
        ]
    }
}
