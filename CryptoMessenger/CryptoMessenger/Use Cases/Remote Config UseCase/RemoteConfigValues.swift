import Foundation

enum RemoteConfigValues: String {

	// Модули
	case chat = "Chat"
	case wallet = "Wallet"
	case calls = "Calls"
    case phrase = "Phrase"
    case chatMenu = "ChatMenuView"
    case chatMenuFeatures = "ChatMenuFeatures"

	// Настройки модуля Чаты
	enum Chat: String {
		case group
		case personal
	}

	// Настройки модуля Кошелек
	enum Wallet: String {
		case auraTab
        case auraTransaction
	}

	// Настройки модуля Звонки
	enum Calls: String {
		case p2pCalls
		case p2pVideoCalls
		case groupCalls
	}

    // Настройки модуля импорта фразы

    enum Phrase: String {
        case phrase
    }

    // Настройки экрана меню чата

    enum ChatMenu: String {
        case chatGroupMenu
        case chatDirectMenu
    }

	// Версии фичей/модулей
	enum Version: String {
		case v1_0 = "1.0"
		case v2_0 = "2.0"
	}

    enum ChatMenuFeature: String {
        case notifications
        case search
        case translate
        case shareChat
        case shareContact
        case media
        case background
        case blockUser
        case clearHistory
        case edit
        case users
        case blackList
    }
}
