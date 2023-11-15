import Foundation

// swiftlint: disable: all

// MARK: - Reaction

struct Reaction: Identifiable, Hashable {

    // MARK: - Internal Properties

    var id: String
    let sender: String
    let timestamp: Date
    let emoji: String
	let isFromCurrentUser: Bool

    // MARK: - Life Cycle

    init(
        id: String,
        sender: String,
        timestamp: Date,
        emoji: String,
        isFromCurrentUser: Bool = false
    ) {
        self.id = id
        self.sender = sender
        self.timestamp = timestamp
        self.emoji = emoji
		self.isFromCurrentUser = isFromCurrentUser
    }

    static func == (lhs: Reaction, rhs: Reaction) -> Bool {
        (lhs.sender == rhs.sender) && (lhs.timestamp == rhs.timestamp) &&
        (lhs.emoji == rhs.emoji) && (lhs.isFromCurrentUser == rhs.isFromCurrentUser)
    }
}
