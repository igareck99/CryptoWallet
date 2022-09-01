import Foundation

enum RemoteConfigValues: String {

	// Модули
	case chat = "Chat"
	case wallet = "Wallet"
	case calls = "Calls"
    case phrase = "Phrase"

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
	}
    
    // Настройки модуля импорта фразы

    enum Phrase: String {
        case phrase
    }

	// Версии фичей/модулей
	enum Version: String {
		case v1_0 = "1.0"
		case v2_0 = "2.0"
	}
}
