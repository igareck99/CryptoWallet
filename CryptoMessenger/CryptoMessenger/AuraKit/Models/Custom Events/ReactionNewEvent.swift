import SwiftUI

// MARK: - ReactionNewEvent

struct ReactionNewEvent: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    var eventId: String
    let sender: String
    let relatedEvent: String
    let timestamp: Date
    let emoji: String
    var width: CGFloat
    let color: Color
    let textColor: Color
    let emojiCount: Int
    let emojiString: String
    let sendersIds: [String]
    let isFromCurrentUser: Bool
    let type: ReactionType
    let onTap: (ReactionNewEvent) -> Void

    // MARK: - Life Cycle

    init(
        eventId: String,
        sender: String,
        relatedEvent: String,
        timestamp: Date,
        emoji: String,
        color: Color,
        emojiString: String,
        textColor: Color = .brilliantAzure,
        emojiCount: Int = 1,
        sendersIds: [String],
        isFromCurrentUser: Bool = false,
        type: ReactionType = .reaction,
        onTap: @escaping (ReactionNewEvent) -> Void
    ) {
        self.eventId = eventId
        self.sender = sender
        self.relatedEvent = relatedEvent
        self.timestamp = timestamp
        self.emoji = emoji
        self.color = color
        self.width = 36
        if emojiCount >= 2 {
            self.width += CGFloat(String(emojiCount).count * 7 + 7)
        }
        if emojiString.contains("+") {
            self.width += CGFloat(String(emojiString.count).count * 7 + 7)
        }
        self.emojiString = emojiString
        self.type = type
        self.isFromCurrentUser = isFromCurrentUser
        self.emojiCount = emojiCount
        self.sendersIds = sendersIds
        self.textColor = textColor
        self.onTap = onTap
    }

    func view() -> AnyView {
        return ReactionNewView(value: self)
            .anyView()
    }

    func getItemWidth() -> CGFloat {
        return self.width
    }
}

// MARK: - ReactionType

enum ReactionType {
    case reaction
    case add
}
