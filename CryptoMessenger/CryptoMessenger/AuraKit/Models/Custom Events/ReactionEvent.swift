import Foundation

// MARK: - ReactionEvent

struct ReactionEvent {

    // MARK: - Internal Properties

    let eventId: String
    let key: String
    let relationType = MXEventRelationTypeAnnotation
}

// MARK: - ReactionEvent (CustomEvent)

extension ReactionEvent: CustomEvent {

    // MARK: - Internal Methods

    func encodeContent() -> [String: Any] {
        [
            "m.relates_to": [
                "event_id": eventId,
                "key": key,
                "rel_type": relationType
            ]
        ]
    }
}
