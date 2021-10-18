import Foundation
import MatrixSDK

struct ReactionEvent {
    let eventId: String
    let key: String
    let relationType = MXEventRelationTypeAnnotation
}

extension ReactionEvent: CustomEvent {
    func encodeContent() throws -> [String: Any] {
        [
            "m.relates_to": [
                "event_id": eventId,
                "key": key,
                "rel_type": relationType
            ]
        ]
    }
}
