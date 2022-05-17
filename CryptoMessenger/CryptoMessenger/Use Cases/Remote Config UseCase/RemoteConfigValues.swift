import Foundation

enum RemoteConfigValues: String {

	// Модули
	case chat = "Chat"
	case wallet = "Wallet"
	case calls = "Calls"

	// Настройки модуля Чаты
	enum Chat: String {
		case group
		case personal
		case p2pCall
	}

	// Настройки модуля Кошелек
	enum Wallet: String {
		case auraTab
	}

	// Настройки модуля Звонки
	enum Calls: String {
		case p2pCalls
	}

	// Версии фичей/модулей
	enum Version: String {
		case v1_0 = "1.0"
		case v2_0 = "2.0"
	}
}
