import Foundation

// MARK: - AppConstants
// swiftlint:disable switch_case_alignment
enum AppConstants: Hashable {
    case appName
    case appVersion
    case licensePage
    case rulesPage
	case pusherUrl
	case bundleId

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
		case .pusherUrl:
            return "https://matrix.aura.ms/_matrix/push/v1/notify"
		case .bundleId:
			return Bundle.main.bundleIdentifier ?? ""
        }
    }
}
