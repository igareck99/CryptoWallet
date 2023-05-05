import Foundation
import MatrixSDK

// MARK: - RoomSummary

@dynamicMemberLookup final class RoomSummary: ObservableObject {

    // MARK: - Internal Properties

    var summary: MXRoomSummary

    var lastMessageDate: Date {
		.init(timeIntervalSince1970: Double(summary.lastMessage?.originServerTs ?? .zero) / 1000)
    }

    // MARK: - Life Cycle

    init(_ summary: MXRoomSummary) {
        self.summary = summary
    }

    // MARK: - Subscript

    subscript<T>(dynamicMember keyPath: KeyPath<MXRoomSummary, T>) -> T { summary[keyPath: keyPath] }
}
