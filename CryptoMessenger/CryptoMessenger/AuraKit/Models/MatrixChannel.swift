import Combine

// MARK: - MatrixChannel

struct MatrixChannel: Hashable {
    
    // MARK: - Internal Properties
    
    var roomId: String
    var name: String
    var numJoinedMembers: Int
    var avatarUrl: String

    // MARK: - Lifecycle

    init(roomId: String, name: String,
         numJoinedMembers: Int, avatarUrl: String) {
        self.roomId = roomId
        self.name = name
        self.numJoinedMembers = numJoinedMembers
        self.avatarUrl = avatarUrl
    }
}
