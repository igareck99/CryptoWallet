import Foundation

final class KeychainService {

	enum Keys: String {
		case homeServer
		case accessToken
		case deviceId
		case pushToken
        case pushVoipToken
		case gmtZeroTimeInterval

        case lastCallEvent
		case apiAccessToken
        case secretPhrase
        case password
		case apiRefreshToken
		case apiUserPhoneNumber
		case apiUserPinCode
		case isPinCodeEnabled
		case apiIsUserAuthenticated

		// Wallets
		case ethereumPrivateKey
		case ethereumPublicKey
        case binancePrivateKey
        case binancePublicKey
		case bitcoinPrivateKey
		case bitcoinPublicKey
	}

	private let keychainWrapper: KeychainWrapper
    static let shared = KeychainServiceAssembly.build()

    init(wrapper: KeychainWrapper) {
        self.keychainWrapper = wrapper
    }
}

// MARK: - KeychainServiceProtocol

extension KeychainService: KeychainServiceProtocol {

    func getAccServiceName() -> String {
        keychainWrapper.serviceName
    }

    func getAccServiceNameId() -> String {
        keychainWrapper.serviceNameId
    }

	// MARK: - Getters

	func integer(forKey key: KeychainService.Keys) -> Int? {
		guard let numberValue = keychainWrapper.object(forKey: key.rawValue) as? NSNumber
		else {
			return nil
		}
		return numberValue.intValue
	}

	func float(forKey key: KeychainService.Keys) -> Float? {
		guard let numberValue = keychainWrapper.object(forKey: key.rawValue) as? NSNumber
		else {
			return nil
		}
		return numberValue.floatValue
	}

	func double(forKey key: KeychainService.Keys) -> Double? {
		guard let numberValue = keychainWrapper.object(forKey: key.rawValue) as? NSNumber
		else {
			return nil
		}
		return numberValue.doubleValue
	}

	func bool(forKey key: KeychainService.Keys) -> Bool? {
		guard let numberValue = keychainWrapper.object(forKey: key.rawValue) as? NSNumber
		else {
			return nil
		}
		return numberValue.boolValue
	}

	func string(forKey key: KeychainService.Keys) -> String? {
		guard let keychainData = keychainWrapper.data(forKey: key.rawValue)
		else {
			return nil
		}
		return String(data: keychainData, encoding: String.Encoding.utf8) as String?
	}

	func data(forKey key: KeychainService.Keys) -> Data? {
		keychainWrapper.data(forKey: key.rawValue)
	}

	// MARK: - Setters

	@discardableResult
	func set(_ value: Int, forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.set(NSNumber(value: value), forKey: key.rawValue)
	}

	@discardableResult
	func set(_ value: Float, forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.set(NSNumber(value: value), forKey: key.rawValue)
	}

	@discardableResult
	func set(_ value: Double, forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.set(NSNumber(value: value), forKey: key.rawValue)
	}

	@discardableResult
	func set(_ value: Bool, forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.set(NSNumber(value: value), forKey: key.rawValue)
	}

	@discardableResult
	func set(_ value: Bool?, forKey key: KeychainService.Keys) -> Bool {
		if let boolValue = value {
			return keychainWrapper.set(boolValue, forKey: key.rawValue)
		}
		return removeObject(forKey: key)
	}

	@discardableResult
	func set(_ value: String, forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.set(value, forKey: key.rawValue)
	}

	@discardableResult
	func set(_ value: String?, forKey key: KeychainService.Keys) -> Bool {
		if let stringValue = value {
			return keychainWrapper.set(stringValue, forKey: key.rawValue)
		}
		return removeObject(forKey: key)
	}

	@discardableResult
	func set(_ value: Data, forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.set(
			value,
			forKey: key.rawValue
		)
	}

	// MARK: - Updaters

	@discardableResult
	func removeObject(forKey key: KeychainService.Keys) -> Bool {
		keychainWrapper.removeObject(
			forKey: key.rawValue
		)
	}
}

// MARK: - Subscripts

extension KeychainService {

	subscript(key: KeychainService.Keys) -> String? {
		get { string(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Bool? {
		get { bool(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Int? {
		get { integer(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Double? {
		get { double(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Float? {
		get { float(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Data? {
		get { data(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}
}
