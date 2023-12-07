import MatrixSDK

struct RoomItem: Codable, Hashable {
    let roomId: String
    let displayName: String
    let messageDate: UInt64

    init(room: MXRoom) {
        self.roomId = room.summary.roomId
        self.displayName = room.summary.displayName ?? ""
        self.messageDate = room.summary.lastMessage.originServerTs
    }

    // MARK: - Equatable

    static func == (lhs: RoomItem, rhs: RoomItem) -> Bool {
        lhs.displayName == rhs.displayName && lhs.roomId == rhs.roomId
    }
}
