import UIKit

// MARK: - UserDefaultSettings

@propertyWrapper
struct UserDefaultSettings<Type> {

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
    private static let isNewFlowFinishedKey = "isWorkerFlowFinishedKey"

    // MARK: - Internal Properties

    @UserDefaultSettings(isUserAuthenticatedKey, value: true)
    var isUserAuthenticated: Bool

    @UserDefaultSettings(authTokenKey, value: "")
    var token: String

    @UserDefaultSettings(authUserIdKey, value: "")
    var userId: String

    @UserDefaultSettings(userPhoneNumberKey, value: "")
    var userPhoneNumber: String

    @UserDefaultSettings(isAuthFlowFinishedKey, value: false)
    var isAuthFlowFinished: Bool

    @UserDefaultSettings(isNewFlowFinishedKey, value: false)
    var isNewFlowFinished: Bool
}

// MARK: - UserDefaultsLayer (UserCredentialsStorage)

extension UserDefaultsLayer: UserCredentialsStorage {}

// MARK: - UserDefaultsLayer (UserFlowsStorage)

extension UserDefaultsLayer: UserFlowsStorage {}
