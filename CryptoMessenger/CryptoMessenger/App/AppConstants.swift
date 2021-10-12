import Foundation

// MARK: - AppConstants

enum AppConstants {
    case appName
    case AppVersion

    static func getConstant(number: Int) -> String {
        switch number {
        case 1:
            return "AURA Wallet Messenger"
        case 2:
            return "Версия 1.10.201"
        case 3:
            return "https://yandex.ru"
        case 4:
            return "https://developer.apple.com"
        default:
            return "undefined"
        }
    }
}
