import Foundation
import MatrixSDK

extension EventCollection {

    // MARK: - Internal Methods

    func relatedEvents(of event: MXEvent) -> [MXEvent] {
        return wrapped.filter { $0.relatesTo?.eventId == event.eventId }
    }

    func reactions(for event: MXEvent) -> [Reaction] {
        relatedEvents(of: event)
            .filter { $0.type == kMXEventTypeStringReaction }
            .compactMap { event in
                guard
                    let id = event.eventId,
                    let sender = event.sender,
                    let relatesToContent = event.content["m.relates_to"] as? [String: Any],
                    let reaction = relatesToContent["key"] as? String
                else {
                    return nil
                }
                return Reaction(
                    id: id,
                    sender: sender,
                    timestamp: event.timestamp,
                    emoji: reaction
                )
            }
    }

    func reactions(
        forEvent event: MXEvent,
        currentUserId: String
    ) -> [Reaction] {
        relatedEvents(of: event)
            .filter { $0.type == kMXEventTypeStringReaction }
            .compactMap { event in
                guard
                    let id = event.eventId,
                    let sender = event.sender,
                    let relatesToContent = event.content["m.relates_to"] as? [String: Any],
                    let reaction = relatesToContent["key"] as? String
                else {
                    return nil
                }
                return Reaction(
                    id: id,
                    sender: sender,
                    timestamp: event.timestamp,
                    emoji: reaction,
                    isFromCurrentUser: currentUserId == sender
                )
            }
    }

    func connectedEdges(of event: MXEvent) -> ConnectedEdges {
        guard let idx = wrapped.firstIndex(of: event) else {
            fatalError("Event not found in event collection.")
        }

        guard idx >= wrapped.startIndex else {
            return []
        }

        // Note to self: `first(where:)` should not filter redacted messages here, since that would skip them and base
        // the decision on the message event before that, possibly wrapping the redaction inside the group. Redacted
        // state is checked separately.
        let precedingMessageEvent = wrapped[..<idx]
            .reversed()
            .first { Self.groupEventTypes.contains($0.type) }

        let succeedingMessageEvent = wrapped[wrapped.index(after: idx)...]
            .first { Self.groupEventTypes.contains($0.type) }

        let isPrecedingRedacted = precedingMessageEvent?.isRedactedEvent() ?? false
        let isSucceedingRedacted = succeedingMessageEvent?.isRedactedEvent() ?? false
        let isPrecedingEdited = precedingMessageEvent?.isEdit() ?? false
        let isSucceedingEdited = succeedingMessageEvent?.isEdit() ?? false

        // If a message is sent within this time interval, it is considered to be part of the current group.
        let timeIntervalBeforeNewGroup: TimeInterval = 5 * 60
        let precedingInterval = precedingMessageEvent.map { event.timestamp.timeIntervalSince($0.timestamp) } ?? 10000
        let succeedingInterval = succeedingMessageEvent?.timestamp.timeIntervalSince(event.timestamp) ?? 10000

        let groupedWithPreceding = event.sender == precedingMessageEvent?.sender
            && !isPrecedingRedacted
            && precedingInterval < timeIntervalBeforeNewGroup
            && !isPrecedingEdited

        let groupedWithSucceeding = event.sender == succeedingMessageEvent?.sender
            && !isSucceedingRedacted
            && succeedingInterval < timeIntervalBeforeNewGroup
            && !isSucceedingEdited

        switch (groupedWithPreceding, groupedWithSucceeding) {
        case (false, false):
            return []
        case (true, false):
            return .topEdge
        case (false, true):
            return .bottomEdge
        case (true, true):
            return [.topEdge, .bottomEdge]
        }
    }
}
