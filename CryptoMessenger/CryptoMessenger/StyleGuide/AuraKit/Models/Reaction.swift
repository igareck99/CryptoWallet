import Foundation

// MARK: - Reaction

struct Reaction: Identifiable {

    // MARK: - Internal Properties

    var id: String
    let sender: String
    let timestamp: Date
    let emoji: String

    // MARK: - Life Cycle

    init(
        id: String,
        sender: String,
        timestamp: Date,
        emoji: String
    ) {
        self.id = id
        self.sender = sender
        self.timestamp = timestamp
        self.emoji = emoji
    }
}

// MARK: - ReactionGroup

struct ReactionGroup: Identifiable {

    // MARK: - Internal Properties

    let reaction: String
    let count: Int
    let reactions: [Reaction]
    var id: String { reaction }

    // MARK: - Life Cycle

    init(reaction: String, count: Int, reactions: [Reaction]) {
        self.reaction = reaction
        self.count = count
        self.reactions = reactions
    }

    // MARK: - Internal Methods

    func containsReaction(from sender: String) -> Bool { reactions.contains { $0.sender == sender } }
}
