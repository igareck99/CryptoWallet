import Foundation
import KeychainAccess

protocol KeychainServiceProtocol {
	func save(string: String, for key: KeychainService.Keys)
	/// Сохраняет строку если таковая еще не хранится
	/// - Returns: вернет true если запись обновлена, иначе false
	@discardableResult
	func updateIfNeeded(string: String, for key: KeychainService.Keys) -> Bool
	func getString(for key: KeychainService.Keys) -> String?
	func contains(string: String, for key: KeychainService.Keys) -> Bool
}

final class KeychainService {

	enum Keys: String {
		case homeServer
		case userId
		case accessToken
		case deviceId
		case pushToken
	}

	private static let keychain = Keychain(service: "chat.aura.credentials")

	init() {}
}

// MARK: - KeychainServiceProtocol

extension KeychainService: KeychainServiceProtocol {

	@discardableResult
	func updateIfNeeded(string: String, for key: KeychainService.Keys) -> Bool {
		if let value = Self.keychain[key],
		   string == value {
			return false
		}
		save(string: string, for: key)
		return true
	}

	func save(string: String, for key: Keys) {
		Self.keychain[key] = string
	}

	func getString(for key: KeychainService.Keys) -> String? {
		let value = Self.keychain[key]
		return value
	}

	func contains(string: String, for key: KeychainService.Keys) -> Bool {
		guard let value = Self.keychain[key] else { return false }
		return string == value
	}
}

private extension Keychain {

	// MARK: - Subscript

	subscript(keychainKey: KeychainService.Keys) -> String? {
		get { try? get(keychainKey.rawValue) }

		set {
			let key = keychainKey.rawValue
			if let value = newValue {
				do {
					try set(value, key: key)
				} catch {}
			} else {
				do {
					try remove(key)
				} catch {}
			}
		}
	}
}
