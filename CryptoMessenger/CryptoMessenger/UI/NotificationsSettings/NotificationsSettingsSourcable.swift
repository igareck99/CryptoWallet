import Foundation

// swiftlint: disable: all
// MARK: - NotificationsSettingsResourcable

protocol NotificationsSettingsResourcable {
    
    static var resetSettings: String { get }
    
    static var additionalMenuNotification: String { get }
    
    static var parametrs: String { get }
    
    static var groups: String { get }
    
    static var messages: String { get }
}

// MARK: - NotificationsSettingsResources(NotificationsSettingsResourcable)

enum NotificationsSettingsResources: NotificationsSettingsResourcable {
    
    static var resetSettings: String {
        "Сбросить настройки уведомлений"
    }
    
    static var additionalMenuNotification: String {
        R.string.localizable.additionalMenuNotification()
    }
    
    static var parametrs: String {
        "Параметры"
    }
    
    static var groups: String {
        "Группы"
    }
    
    static var messages: String {
        "Сообщения"
    }
}
