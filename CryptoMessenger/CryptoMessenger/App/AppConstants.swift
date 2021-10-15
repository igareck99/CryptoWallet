import Foundation

// MARK: - AppConstants

enum AppConstants: Hashable {
    case appName
    case appVersion
    case licensePage
    case rulesPage

    // MARK: - Internal Properties

    var aboutApp: String {
        switch self {
        case .appName:
            return "AURA Wallet Messenger"
        case .appVersion:
            return "Версия 1.10.201"
        case .licensePage:
            return "https://yandex.ru"
        case .rulesPage:
            return "https://developer.apple.com"
        }
    }
}
