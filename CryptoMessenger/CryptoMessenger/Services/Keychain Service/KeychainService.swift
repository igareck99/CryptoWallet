import Foundation

final class KeychainService {

	enum Keys: String {
		case homeServer
		case userId
		case accessToken
		case deviceId
		case pushToken
		case gmtZeroTimeInterval
	}

	private enum Constants {
		static let accessGroup = "ru.aura.app.keychain.accessGroup"
		static let serviceName = "ru.aura.app.keychain.service"
	}

	private let accessGroup: String?
	private let serviceName: String
	private var keychainWrapper: KeychainWrapper
	static let shared = KeychainService(accessGroup: nil, serviceName: Constants.serviceName)

	init(
		accessGroup: String? = Constants.accessGroup,
		serviceName: String = Constants.serviceName
	) {
		self.accessGroup = accessGroup
		self.serviceName = serviceName
		self.keychainWrapper = KeychainWrapper(serviceName: serviceName, accessGroup: accessGroup)

	}
}

// MARK: - KeychainServiceProtocol

extension KeychainService: KeychainServiceProtocol {
	// MARK: - Getters Wrappers

	func integer(forKey key: KeychainService.Keys) -> Int? {
		integer(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	func float(forKey key: KeychainService.Keys) -> Float? {
		float(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	func double(forKey key: KeychainService.Keys) -> Double? {
		double(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	func bool(forKey key: KeychainService.Keys) -> Bool? {
		bool(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	func string(forKey key: KeychainService.Keys) -> String? {
		string(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	func data(forKey key: KeychainService.Keys) -> Data? {
		data(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	// MARK: - Setters Wrappers

	@discardableResult
	func set(_ value: Int, forKey key: KeychainService.Keys) -> Bool {
		set(value, forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	@discardableResult
	func set(_ value: Float, forKey key: KeychainService.Keys) -> Bool {
		set(value, forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	@discardableResult
	func set(_ value: Double, forKey key: KeychainService.Keys) -> Bool {
		set(value, forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	@discardableResult
	func set(_ value: Bool, forKey key: KeychainService.Keys) -> Bool {
		set(value, forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	@discardableResult
	func set(_ value: String, forKey key: KeychainService.Keys) -> Bool {
		set(value, forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	@discardableResult
	func set(_ value: Data, forKey key: KeychainService.Keys) -> Bool {
		set(value, forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	// MARK: - Updaters Wrappers

	@discardableResult
	func removeObject(forKey key: KeychainService.Keys) -> Bool {
		removeObject(forKey: key, withAccessibility: nil, isSynchronizable: false)
	}

	// MARK: - Getters

	func integer(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Int? {
		guard
			let numberValue = keychainWrapper.object(
				forKey: key.rawValue,
				withAccessibility: accessibility,
				isSynchronizable: isSynchronizable
			) as? NSNumber
		else {
			return nil
		}
		return numberValue.intValue
	}

	func float(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Float? {
		guard
			let numberValue = keychainWrapper.object(
				forKey: key.rawValue,
				withAccessibility: accessibility,
				isSynchronizable: isSynchronizable
			) as? NSNumber
		else {
			return nil
		}
		return numberValue.floatValue
	}

	func double(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Double? {
		guard
			let numberValue = keychainWrapper.object(
				forKey: key.rawValue,
				withAccessibility: accessibility,
				isSynchronizable: isSynchronizable
			) as? NSNumber
		else {
			return nil
		}
		return numberValue.doubleValue
	}

	func bool(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool? {
		guard
			let numberValue = keychainWrapper.object(
				forKey: key.rawValue,
				withAccessibility: accessibility,
				isSynchronizable: isSynchronizable
			) as? NSNumber
		else {
			return nil
		}
		return numberValue.boolValue
	}

	func string(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> String? {
		guard
			let keychainData = keychainWrapper.data(
				forKey: key.rawValue,
				withAccessibility: accessibility,
				isSynchronizable: isSynchronizable
			)
		else {
			return nil
		}
		return String(data: keychainData, encoding: String.Encoding.utf8) as String?
	}

	func data(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Data? {
		keychainWrapper.data(
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	// MARK: - Setters

	@discardableResult
	func set(
		_ value: Int,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.set(
			NSNumber(value: value),
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	@discardableResult
	func set(
		_ value: Float,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.set(
			NSNumber(value: value),
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	@discardableResult
	func set(
		_ value: Double,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.set(
			NSNumber(value: value),
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	@discardableResult
	func set(
		_ value: Bool,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.set(
			NSNumber(value: value),
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	@discardableResult
	func set(
		_ value: String,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.set(
			value,
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	@discardableResult
	func set(
		_ value: Data,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.set(
			value,
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}

	// MARK: - Updaters

	@discardableResult
	func removeObject(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility? = nil,
		isSynchronizable: Bool = false
	) -> Bool {
		keychainWrapper.removeObject(
			forKey: key.rawValue,
			withAccessibility: accessibility,
			isSynchronizable: isSynchronizable
		)
	}
}

extension KeychainService {

	subscript(key: KeychainService.Keys) -> String? {
		get { return string(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Bool? {
		get { return bool(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Int? {
		get { return integer(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Double? {
		get { return double(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Float? {
		get { return float(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: KeychainService.Keys) -> Data? {
		get { return data(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}
}
