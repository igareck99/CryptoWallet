import Foundation

// MARK: - NotificationSettingsItems

enum NotificationSettingsItems {

    // MARK: - Internal Properties

    case messageNotification
    case messagePriority
    case groupNotification
    case groupPriority
    case parametersMessage
    case parametersCalls

    var title: String {
        switch self {
        case .messageNotification:
            return "Уведомления"
        case .messagePriority:
            return "Приоритетные"
        case .groupNotification:
            return "Уведомления"
        case .groupPriority:
            return "Приоритетные"
        case .parametersMessage:
            return "Уведомления о сообщениях"
        case .parametersCalls:
            return "Уведомления о звонках"
        }
    }

    var description: String {
        switch self {
        case .messagePriority:
            return "Показывать как приоритетные"
        case .groupNotification:
            return "Показывать как приоритетные"
        case .parametersMessage:
            return "Звук, вибрация, баннеры"
        case .parametersCalls:
            return "Звук, вибрация, баннеры"
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
