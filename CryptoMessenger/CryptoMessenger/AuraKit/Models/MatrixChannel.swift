import SwiftUI

// MARK: - MatrixChannel

struct MatrixChannel: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    var roomId: String
    var name: String
    var numJoinedMembers: Int
    var avatarUrl: String
    var isJoined: Bool
    var onTap: (MatrixChannel) -> Void

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        ChatHistorySearchRow(data: self)
            .anyView()
    }
}
