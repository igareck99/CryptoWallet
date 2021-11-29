import KeychainAccess
import MatrixSDK
import UIKit

// MARK: - UserDefaultSettings

@propertyWrapper struct UserDefaultSettings<Type> {

    // MARK: - Private Properties

    private let key: String
    private let value: Type
    private let defaults: UserDefaults

    // MARK: - Internal Properties

    var wrappedValue: Type {
        get { defaults.object(forKey: key) as? Type ?? value }
        set { defaults.set(newValue, forKey: key) }
    }

    // MARK: - Lifecycle

    init(_ key: String, value: Type, for defaults: UserDefaults = .standard) {
        self.key = key
        self.value = value
        self.defaults = defaults
    }
}

// MARK: - UserDefaultsLayer

struct UserDefaultsLayer {

    // MARK: - Private Properties

    private static let isUserAuthenticatedKey = "isUserAuthenticatedKey"
    private static let authTokenKey = "authTokenKey"
    private static let authUserIdKey = "authUserIdKey"
    private static let userPhoneNumberKey = "userPhoneNumberKey"
    private static let isAuthFlowFinishedKey = "isAuthFlowFinishedKey"
    private static let isOnboardingFlowFinishedKey = "isOnboardingFlowFinishedKey"
    private static let isLocalAuthKey = "isLocalAuthKey"
    private static let isLocalAuthBackgroundAlertShownKey = "isLocalAuthBackgroundAlertShownKey"
    private static let isLocalAuthInBackgroundKey = "isLocalAuthInBackgroundKey"
    private static let userPinCodeKey = "userPinCodeKey"
    private static let isPinCodeOnKey = "isPinCodeOnKey"
    private static let userFalsePinCodeKey = "userFalsePinCodeKey"
    private static let isFalsePinCodeOnKey = "isFalsePinCodeOnKey"

    // MARK: - Internal Properties

    @UserDefaultSettings(isUserAuthenticatedKey, value: false)
    var isUserAuthenticated: Bool

    @UserDefaultSettings(authTokenKey, value: "")
    var token: String

    @UserDefaultSettings(authUserIdKey, value: "")
    var userId: String

    @UserDefaultSettings(userPhoneNumberKey, value: "")
    var userPhoneNumber: String

    @UserDefaultSettings(isAuthFlowFinishedKey, value: false)
    var isAuthFlowFinished: Bool

    @UserDefaultSettings(isOnboardingFlowFinishedKey, value: false)
    var isOnboardingFlowFinished: Bool

    @UserDefaultSettings(isLocalAuthKey, value: false)
    var isLocalAuth: Bool

    @UserDefaultSettings(isLocalAuthBackgroundAlertShownKey, value: false)
    var isLocalAuthBackgroundAlertShown: Bool

    @UserDefaultSettings(isLocalAuthInBackgroundKey, value: false)
    var isLocalAuthInBackground: Bool

    @UserDefaultSettings(userPinCodeKey, value: "")
    var userPinCode: String

    @UserDefaultSettings(isPinCodeOnKey, value: false)
    var isPinCodeOn: Bool

    @UserDefaultSettings(isFalsePinCodeOnKey, value: false)
    var isFalsePinCodeOn: Bool

    @UserDefaultSettings(userFalsePinCodeKey, value: "")
    var userFalsePinCode: String

    var userMatrixId: String {
        MXCredentials.from(Keychain(service: "chat.aura.credentials"))?.userId ?? ""
    }
}

// MARK: - UserDefaultsLayer (UserCredentialsStorage)

extension UserDefaultsLayer: UserCredentialsStorage {}

// MARK: - UserDefaultsLayer (UserFlowsStorage)

extension UserDefaultsLayer: UserFlowsStorage {}
