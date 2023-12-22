import Foundation

// MARK: - QuickActionItem

struct QuickActionItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let action: QuickActionCurrentUser
}
