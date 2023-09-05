import SwiftUI

// MARK: - ReactionNewEvent

struct ReactionNewEvent: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    var eventId: String
    let sender: String
    let timestamp: Date
    let emoji: String
    var width: CGFloat
    let color: Color
    let textColor: Color
    let emojiCount: Int
    let isFromCurrentUser: Bool
    let onTap: (ReactionNewEvent) -> Void

    // MARK: - Life Cycle

    init(
        eventId: String,
        sender: String,
        timestamp: Date,
        emoji: String,
        color: Color,
        emojiCount: Int = 1,
        isFromCurrentUser: Bool = false,
        onTap: @escaping (ReactionNewEvent) -> Void
    ) {
        self.eventId = eventId
        self.sender = sender
        self.timestamp = timestamp
        self.emoji = emoji
        self.color = color
        self.width = 38
        if emojiCount > 1 {
            self.width += CGFloat(String(emojiCount).count * 7 + 7)
        }
        self.isFromCurrentUser = isFromCurrentUser
        self.emojiCount = emojiCount
        self.textColor = .brilliantAzure
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
