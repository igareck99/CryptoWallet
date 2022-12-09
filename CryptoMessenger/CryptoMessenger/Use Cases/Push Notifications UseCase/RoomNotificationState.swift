import Foundation

// MARK: - RoomNotificationState

enum RoomNotificationState: Int {
    case all
    case mentionsAndKeywordsOnly
    case mute
}

extension RoomNotificationState: CaseIterable { }

extension RoomNotificationState: Identifiable {
    var id: Int { rawValue }
}

extension RoomNotificationState {
    var title: String {
        switch self {
        case .all:
            return ""
        case .mentionsAndKeywordsOnly:
            return ""
        case .mute:
            return ""
        }
    }
}
