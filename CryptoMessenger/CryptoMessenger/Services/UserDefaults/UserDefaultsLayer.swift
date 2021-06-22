import UIKit

// MARK: - UserDefaultSettings

@propertyWrapper
struct UserDefaultSettings<Type> {
    private let key: String
    private let value: Type
    private let defaults: UserDefaults

    init(_ key: String, value: Type, for defaults: UserDefaults = .standard) {
        self.key = key
        self.value = value
        self.defaults = defaults
    }

    var wrappedValue: Type {
        get {
            defaults.object(forKey: key) as? Type ?? value
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}

// MARK: - UserDefaultsLayer

final class UserDefaultsLayer {

    // MARK: - Public Properties

    static let storage = UserDefaultsLayer()

    let auth = AuthDefaultsLayer()
    let flows = FlowsDefaultsLayer()
}

// MARK: UserDefaultsLayer (AuthUserDefaultsLayer)

extension UserDefaultsLayer {
    final class AuthDefaultsLayer: UserCredentialsStorage {
        private static let isUserAuthenticatedKey = "isUserAuthenticatedKey"
        private static let authTokenKey = "authTokenKey"
        private static let authUserIdKey = "authUserIdKey"

        @UserDefaultSettings(isUserAuthenticatedKey, value: true)
        var isUserAuthenticated: Bool

        @UserDefaultSettings(authTokenKey, value: "d8874a6f-a45a-4fa8-8b3b-9a11b2805034")
        var token: String

        @UserDefaultSettings(authUserIdKey, value: "123")
        var userId: String
    }
}

// MARK: UserDefaultsLayer (AuthUserDefaultsLayer)

extension UserDefaultsLayer {
    final class FlowsDefaultsLayer: UserFlowsStorage {
        private static let isAuthFlowFinishedKey = "isAuthFlowFinishedKey"
        private static let isNewFlowFinishedKey = "isWorkerFlowFinishedKey"

        @UserDefaultSettings(isAuthFlowFinishedKey, value: false)
        var isAuthFlowFinished: Bool

        @UserDefaultSettings(isNewFlowFinishedKey, value: false)
        var isNewFlowFinished: Bool
    }
}
