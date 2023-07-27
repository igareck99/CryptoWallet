import Foundation

// MARK: - NotificationSettingsItems

enum NotificationSettingsItems {

    // MARK: - Internal Properties

    case allMessages
    case mentionsOnly
    case mute
    case userAccount
    case onDevice

    var title: String {
        switch self {
        case .allMessages:
            return "Все сообщения"
        case .mentionsOnly:
            return "Только упоминания и ключевые слова"
        case .mute:
            return "Отсутствует"
        case .userAccount:
            return "Учетная запись"
        case .onDevice:
            return "На устройстве"
        }
    }

    var description: String {
        switch self {
        case .userAccount:
            return "Все активные сессии"
        case .onDevice:
            return "Текущая сессия"
        default:
            return ""
        }
    }
}

// MARK: - NotificationSettings

struct NotificationSettings {

    // MARK: - Internal Properties

    var item: NotificationSettingsItems
    var state: Bool
}
