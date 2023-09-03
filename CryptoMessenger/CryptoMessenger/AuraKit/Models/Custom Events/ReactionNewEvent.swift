import SwiftUI

// MARK: - ReactionNewEvent

struct ReactionNewEvent: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    var eventId: String
    let sender: String
    let timestamp: Date
    let emoji: String
    let width: CGFloat
    let color: Color
    let emojiCount: Int
    let isFromCurrentUser: Bool

    // MARK: - Life Cycle

    init(
        eventId: String,
        sender: String,
        timestamp: Date,
        emoji: String,
        color: Color,
        emojiCount: Int = 1,
        isFromCurrentUser: Bool = false
    ) {
        self.eventId = eventId
        self.sender = sender
        self.timestamp = timestamp
        self.emoji = emoji
        self.color = color
        self.width = CGFloat(43 + String(emojiCount).count * 7)
        self.isFromCurrentUser = isFromCurrentUser
        self.emojiCount = 1
    }
    
    func view() -> AnyView {
        return ReactionNewView(value: self)
            .anyView()
    }
    
    func getItemWidth() -> CGFloat {
        return self.width
    }
}
