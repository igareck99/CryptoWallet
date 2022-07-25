import Combine
import Foundation

final class UserDefaultsService {

	enum Keys: String {

		case pushKey
		case isAppNotFirstStart
		case isPushNotificationsEnabled
		case roomList
		case isCallInprogressExists

		// UserFlowsStorage
		case isAuthFlowFinished
		case isOnboardingFlowFinished
		case isLocalAuth
		case isLocalAuthBackgroundAlertShown
		case isLocalAuthInBackground
		case isFalsePinCodeOn
		case isBiometryOn
		case saveToPhotos

		// UserCredentialsStorage
		case typography
		case language
		case theme
		case profileBackgroundImage
		case telephoneState
		case profileObserveState
		case lastSeenState
		case callsState
		case geopositionState
		case reserveCopyTime
		case secretPhraseState
	}

	private let storage: UserDefaults
	lazy var inProgressCallSubject = CurrentValueSubject<Bool, Never>(isCallInprogressExists)

	static let shared: UserDefaultsService = {
		let storage = UserDefaults(suiteName: "com.aura.app.user_defaults.storage") ?? .standard
		let userDefaults = UserDefaultsService(storage: storage)
		return userDefaults
	}()

	init(storage: UserDefaults) {
		self.storage = storage
	}
}

// MARK: - UserDefaultsServiceProtocol

extension UserDefaultsService: UserDefaultsServiceProtocol {

	// MARK: - Getters

	func data(forKey key: UserDefaultsService.Keys) -> Data? {
		storage.data(forKey: key.rawValue)
	}

	func bool(forKey key: UserDefaultsService.Keys) -> Bool {
		storage.bool(forKey: key.rawValue)
	}

	func integer(forKey key: UserDefaultsService.Keys) -> Int {
		storage.integer(forKey: key.rawValue)
	}

	func string(forKey key: UserDefaultsService.Keys) -> String? {
		storage.string(forKey: key.rawValue)
	}

	func double(forKey key: UserDefaultsService.Keys) -> Double? {
		storage.double(forKey: key.rawValue)
	}

	func float(forKey key: UserDefaultsService.Keys) -> Float? {
		storage.float(forKey: key.rawValue)
	}

	// MARK: - Setters

	func set(_ data: Data, forKey key: UserDefaultsService.Keys) {
		storage.set(data, forKey: key.rawValue)
	}

	func set(_ bool: Bool, forKey key: UserDefaultsService.Keys) {
		storage.set(bool, forKey: key.rawValue)
	}

	func set(_ integer: Int, forKey key: UserDefaultsService.Keys) {
		storage.set(integer, forKey: key.rawValue)
	}

	func set(_ string: String?, forKey key: UserDefaultsService.Keys) {
		storage.set(string, forKey: key.rawValue)
	}

	func set(_ double: Double, forKey key: UserDefaultsService.Keys) {
		storage.set(double, forKey: key.rawValue)
	}

	func set(_ float: Float, forKey key: UserDefaultsService.Keys) {
		storage.set(float, forKey: key.rawValue)
	}

	// MARK: - Delete

	func remoVeObject(forKey key: UserDefaultsService.Keys) {
		storage.removeObject(forKey: key.rawValue)
	}
}

// MARK: - Subscripts

extension UserDefaultsService {

	subscript(key: UserDefaultsService.Keys) -> String? {
		get { string(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: UserDefaultsService.Keys) -> Bool? {
		get { bool(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: UserDefaultsService.Keys) -> Int? {
		get { integer(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: UserDefaultsService.Keys) -> Double? {
		get { double(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: UserDefaultsService.Keys) -> Float? {
		get { float(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}

	subscript(key: UserDefaultsService.Keys) -> Data? {
		get { data(forKey: key) }
		set {
			guard let value = newValue else { return }
			set(value, forKey: key)
		}
	}
}
