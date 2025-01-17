import Foundation

// Приставка api означает, что эти поля раньше хранились в User Defaults
// apiAccessToken - для https://api.aura...
// accessToken - для https://matrix.aura...
extension KeychainService {

	var apiAccessToken: String? {
		get { string(forKey: .apiAccessToken) }
		set { set(newValue, forKey: .apiAccessToken) }
	}
    
    var secretPhrase: String? {
        get { string(forKey: .secretPhrase) }
        set { set(newValue, forKey: .secretPhrase) }
    }

	var apiRefreshToken: String? {
		get { string(forKey: .apiRefreshToken) }
		set { set(newValue, forKey: .apiRefreshToken) }
	}

	var apiUserId: String? {
		get { string(forKey: .apiUserId) }
		set { set(newValue, forKey: .apiUserId) }
	}

	var apiUserMatrixId: String? {
		get { string(forKey: .apiUserMatrixId) }
		set { set(newValue, forKey: .apiUserMatrixId) }
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
}
