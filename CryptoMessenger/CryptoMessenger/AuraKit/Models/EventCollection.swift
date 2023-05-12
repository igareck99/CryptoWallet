import Foundation
import MatrixSDK

// MARK: - EventCollection

struct EventCollection {

    static let groupEventTypes = [
        kMXEventTypeStringRoomMessage
    ]

    static let renderableEventTypes = [
        kMXEventTypeStringRoomMessage,
        kMXEventTypeStringRoomMember,
        kMXEventTypeStringRoomTopic,
        kMXEventTypeStringRoomPowerLevels,
        kMXEventTypeStringRoomEncryption,
        kMXEventTypeStringRoomName,
        kMXMessageTypeImage,
        kMXMessageTypeAudio,
        kMXEventTypeStringRoomEncrypted,
        MXEventCustomEvent.contactInfo.identifier,
        kMXEventTypeStringRoomAvatar,
        kMXMessageTypeLocation,
        kMXEventTypeStringCallHangup,
        kMXEventTypeStringCallReject,
        "m.widget",
        "im.vector.modular.widgets",
        "jitsi",
        "m.jitsi",
        "m.reaction"
    ]

    /// Events that can be directly rendered in the timeline with a corresponding view. This for example does not
    /// include reactions, which are instead rendered as accessories on their corresponding related events.
    var renderableEvents: [MXEvent] {
        return wrapped.filter {
            return Self.renderableEventTypes.contains($0.type)
        }.reversed()
    }

    // MARK: - Internal Properties

    var wrapped: [MXEvent]

    // MARK: - Life Cycle

    init(_ events: [MXEvent]) {
        self.wrapped = events
    }
}
