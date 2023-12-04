import Foundation
import MatrixSDK

// MARK: - RoomSummary

final class RoomSummary: ObservableObject {

    // MARK: - Internal Properties

    var summary: MXRoomSummary?

    var lastMessageDate: Date {
		.init(timeIntervalSince1970: Double(summary?.lastMessage?.originServerTs ?? .zero) / 1000)
    }

    var displayName: String {
        summary?.displayName ?? "roomName"
    }

    var localUnreadEventCount: UInt {
        summary?.localUnreadEventCount ?? .zero
    }

    var membersCount: UInt {
        summary?.membersCount?.members ?? 1
    }

    var avatar: String {
        summary?.avatar ?? ""
    }

    // MARK: - Life Cycle

    init(_ summary: MXRoomSummary) {
        self.summary = summary
    }
}
