import Foundation

enum RemoteConfigValues: String {

	// Модули
	case chat = "Chat"
	case wallet = "Wallet"
	case calls = "Calls"
    case phrase = "Phrase"
    case chatMenu = "ChatMenuView"
    case chatMenuFeatures = "ChatMenuFeatures"
    case files = "Files"
    case chatMessageActions = "ChatMessageActions"
	case techToggles = "TechToggles"

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
    
    // Настройки Действий с сообщением
    
    enum ChatMessageActions: String {
        case reactions
    }

    // Настройки файлов

    enum Files: String {
        case files
    }

	// Технические рубильники
	
	enum TechToggles: String {
		case chatListTimer // Таймер опроса матрикс комнат
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
