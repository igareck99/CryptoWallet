import Foundation

protocol UserFlowsStorage: UserDefaultsServiceProtocol {
	var isAuthFlowFinished: Bool { get set }
	var isOnboardingFlowFinished: Bool { get set }

	// Нужно ли отображать локальную авторизацию (экран ввода пин кода)
	// true - отображаем, false - не нужно отображать
	var isLocalAuth: Bool { get set }
	var isLocalAuthBackgroundAlertShown: Bool { get set }
	var isLocalAuthInBackground: Bool { get set }
	var isFalsePinCodeOn: Bool { get set }
	var isBiometryOn: Bool { get set }
	var saveToPhotos: Bool { get set }
}

// MARK: - UserFlowsStorage

extension UserDefaultsService: UserFlowsStorage {
	var isAuthFlowFinished: Bool {
		get { bool(forKey: .isAuthFlowFinished) }
		set { set(newValue, forKey: .isAuthFlowFinished) }
	}

	var isOnboardingFlowFinished: Bool {
		get { bool(forKey: .isOnboardingFlowFinished) }
		set { set(newValue, forKey: .isOnboardingFlowFinished) }
	}

	var isLocalAuth: Bool {
		get { bool(forKey: .isLocalAuth) }
		set { set(newValue, forKey: .isLocalAuth) }
	}

	var isLocalAuthBackgroundAlertShown: Bool {
		get { bool(forKey: .isLocalAuthBackgroundAlertShown) }
		set { set(newValue, forKey: .isLocalAuthBackgroundAlertShown) }
	}

	var isLocalAuthInBackground: Bool {
		get { bool(forKey: .isLocalAuthInBackground) }
		set { set(newValue, forKey: .isLocalAuthInBackground) }
	}

	var isFalsePinCodeOn: Bool {
		get { bool(forKey: .isFalsePinCodeOn) }
		set { set(newValue, forKey: .isFalsePinCodeOn) }
	}

	var isBiometryOn: Bool {
		get { bool(forKey: .isBiometryOn) }
		set { set(newValue, forKey: .isBiometryOn) }
	}

	var saveToPhotos: Bool {
		get { bool(forKey: .saveToPhotos) }
		set { set(newValue, forKey: .saveToPhotos) }
	}
}
