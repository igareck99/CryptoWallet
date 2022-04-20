import Foundation

protocol UserCredentialsStorage: AnyObject {
	var isUserAuthenticated: Bool { get set }
	var accessToken: String? { get set }
	var refreshToken: String? { get set }
	var userId: String? { get set }
	var userPhoneNumber: String? { get set }
	var userMatrixId: String? { get }
	var userPinCode: String? { get set }
	var userFalsePinCode: String? { get set }
	var typography: String? { get set }
	var language: String? { get set }
	var theme: String? { get set }
	var profileBackgroundImage: Int { get set }
	var telephoneState: String? { get set }
	var profileObserveState: String? { get set }
	var lastSeenState: String? { get set }
	var callsState: String? { get set }
	var geopositionState: String? { get set }
	var reserveCopyTime: String? { get set }
	var secretPhraseState: String? { get set }
}

// MARK: - UserCredentialsStorage

extension UserDefaultsService: UserCredentialsStorage {
	var isUserAuthenticated: Bool {
		get { bool(forKey: .isUserAuthenticated) }
		set { set(newValue, forKey: .isUserAuthenticated) }
	}

	// TODO: Сохранить в keychain
	var accessToken: String? {
		get { string(forKey: .accessToken) }
		set { set(newValue, forKey: .accessToken) }
	}

	// TODO: Сохранить в keychain
	var refreshToken: String? {
		get { string(forKey: .refreshToken) }
		set { set(newValue, forKey: .refreshToken) }
	}

	// TODO: Сохранить в keychain
	var userId: String? {
		get { string(forKey: .userId) }
		set { set(newValue, forKey: .userId) }
	}

	// TODO: Сохранить в keychain
	var userPhoneNumber: String? {
		get { string(forKey: .userPhoneNumber) }
		set { set(newValue, forKey: .userPhoneNumber) }
	}

	// TODO: Сохранить в keychain
	var userPinCode: String? {
		get { string(forKey: .userPinCode) }
		set { set(newValue, forKey: .userPinCode) }
	}

	var userFalsePinCode: String? {
		get { string(forKey: .userPinCode) }
		set { set(newValue, forKey: .userPinCode) }
	}

	// TODO: Сохранить в keychain
	var userMatrixId: String? {
		string(forKey: .userMatrixId)
	}

	var typography: String? {
		get { string(forKey: .typography) }
		set { set(newValue, forKey: .typography) }
	}

	var language: String? {
		get { string(forKey: .language) }
		set { set(newValue, forKey: .language) }
	}

	var theme: String? {
		get { string(forKey: .theme) }
		set { set(newValue, forKey: .theme) }
	}

	var profileBackgroundImage: Int {
		get { integer(forKey: .profileBackgroundImage) }
		set { set(newValue, forKey: .profileBackgroundImage) }
	}

	var telephoneState: String? {
		get { string(forKey: .telephoneState) }
		set { set(newValue, forKey: .telephoneState) }
	}

	var profileObserveState: String? {
		get { string(forKey: .profileObserveState) }
		set { set(newValue, forKey: .profileObserveState) }
	}

	var lastSeenState: String? {
		get { string(forKey: .lastSeenState) }
		set { set(newValue, forKey: .lastSeenState) }
	}

	var callsState: String? {
		get { string(forKey: .callsState) }
		set { set(newValue, forKey: .callsState) }
	}

	var geopositionState: String? {
		get { string(forKey: .geopositionState) }
		set { set(newValue, forKey: .geopositionState) }
	}

	var reserveCopyTime: String? {
		get { string(forKey: .reserveCopyTime) }
		set { set(newValue, forKey: .reserveCopyTime) }
	}

	var secretPhraseState: String? {
		get { string(forKey: .secretPhraseState) }
		set { set(newValue, forKey: .secretPhraseState) }
	}
}
