import Foundation

// apiAccessToken - для https://api.aura...
// accessToken - для https://matrix.aura...
extension KeychainService {

    var walletRefreshToken: String? {
        get { string(forKey: .walletRefreshToken) }
        set { set(newValue, forKey: .walletRefreshToken) }
    }

    var walletAccessToken: String? {
        get { string(forKey: .walletAccessToken) }
        set { set(newValue, forKey: .walletAccessToken) }
    }

	var apiAccessToken: String? {
		get { string(forKey: .apiAccessToken) }
		set { set(newValue, forKey: .apiAccessToken) }
	}

    var secretPhrase: String? {
        get { string(forKey: .secretPhrase) }
        set {
            set(newValue, forKey: .secretPhrase)
            seedPublisher.send(newValue)
        }
    }

	var apiRefreshToken: String? {
		get { string(forKey: .apiRefreshToken) }
		set { set(newValue, forKey: .apiRefreshToken) }
	}

	var apiUserPhoneNumber: String? {
		get { string(forKey: .apiUserPhoneNumber) }
		set { set(newValue, forKey: .apiUserPhoneNumber) }
	}

	var isApiUserAuthenticated: Bool? {
		get { bool(forKey: .apiIsUserAuthenticated) }
		set { set(newValue, forKey: .apiIsUserAuthenticated) }
	}

	var apiUserPinCode: String? {
		get { string(forKey: .apiUserPinCode) }
		set { set(newValue, forKey: .apiUserPinCode) }
	}

	var isPinCodeEnabled: Bool? {
		get { bool(forKey: .isPinCodeEnabled) }
		set { set(newValue, forKey: .isPinCodeEnabled) }
	}

	var apiUserFalsePinCode: String? {
		get { string(forKey: .apiUserPinCode) }
		set { set(newValue, forKey: .apiUserPinCode) }
	}

    var homeServer: String? {
        get { string(forKey: .homeServer) }
        set { set(newValue, forKey: .homeServer) }
    }

    var accessToken: String? {
        get {
            let aToken = string(forKey: .accessToken)
            debugPrint("MATRIX DEBUG KeychainService get accessToken \(aToken)")
            return aToken
        }
        set {
            debugPrint("MATRIX DEBUG KeychainService set accessToken \(newValue)")
            set(newValue, forKey: .accessToken)
        }
    }

    var deviceId: String? {
        get { string(forKey: .deviceId) }
        set { set(newValue, forKey: .deviceId) }
    }
}
