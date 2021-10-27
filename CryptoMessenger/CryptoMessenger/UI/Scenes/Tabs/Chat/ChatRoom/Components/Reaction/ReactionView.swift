import SwiftUI

// MARK: - ReactionStorage

struct ReactionStorage: Identifiable {

    // MARK: - Internal Properties

    var id: String
    let emoji: String
    var isLastButton = false
}

// MARK: - Reaction

//struct Reaction: Identifiable {
//
//    // MARK: - Internal Properties
//
//    var id: String
//    let sender: String
//    let timestamp: Date
//    let emoji: String
//}
