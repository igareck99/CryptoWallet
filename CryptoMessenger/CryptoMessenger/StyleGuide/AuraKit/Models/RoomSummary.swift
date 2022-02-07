import Foundation
import MatrixSDK

@dynamicMemberLookup
final class RoomSummary: ObservableObject {
    var summary: MXRoomSummary

    var lastMessageDate: Date {
        Date(timeIntervalSince1970: Double(summary.lastMessageOriginServerTs) / 1000)
    }

    init(_ summary: MXRoomSummary) {
        self.summary = summary
    }

    subscript<T>(dynamicMember keyPath: KeyPath<MXRoomSummary, T>) -> T {
        summary[keyPath: keyPath]
    }
}
