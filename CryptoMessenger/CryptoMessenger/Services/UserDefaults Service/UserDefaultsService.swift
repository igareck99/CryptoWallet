import Foundation

protocol UserDefaultsServiceProtocol: AnyObject {
	// Setters
	func set(_ data: Data, forKey key: UserDefaultsService.Keys)
	func set(_ bool: Bool, forKey key: UserDefaultsService.Keys)
	func set(_ integer: Int, forKey key: UserDefaultsService.Keys)
	func set(_ string: String?, forKey key: UserDefaultsService.Keys)

	// Getters
	func data(forKey key: UserDefaultsService.Keys) -> Data?
	func bool(forKey key: UserDefaultsService.Keys) -> Bool
	func integer(forKey key: UserDefaultsService.Keys) -> Int
	func string(forKey key: UserDefaultsService.Keys) -> String?
}

final class UserDefaultsService {

	enum Keys: String {

		case pushKey

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
		case isUserAuthenticated
		case accessToken
		case refreshToken
		case userId
		case userPhoneNumber
		case userMatrixId
		case userPinCode
		case userFalsePinCode
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
}
