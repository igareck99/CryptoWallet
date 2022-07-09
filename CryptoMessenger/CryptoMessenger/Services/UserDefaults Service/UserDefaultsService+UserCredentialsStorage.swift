import Foundation

protocol UserCredentialsStorage: UserDefaultsServiceProtocol {
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
