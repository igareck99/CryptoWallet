import KeychainAccess
import MatrixSDK

extension MXCredentials {
    public func save(to keychain: Keychain) {
        guard
            let homeServer = homeServer,
            let userId = userId,
            let accessToken = accessToken,
            let deviceId = deviceId
        else {
            return
        }
        keychain["homeServer"] = homeServer
        keychain["userId"] = userId
        keychain["accessToken"] = accessToken
        keychain["deviceId"] = deviceId
    }

    public func clear(from keychain: Keychain) {
        keychain["homeServer"] = nil
        keychain["userId"] = nil
        keychain["accessToken"] = nil
        keychain["deviceId"] = nil
    }

    public static func from(_ keychain: Keychain) -> MXCredentials? {
        guard
            let homeServer = keychain["homeServer"],
            let userId = keychain["userId"],
            let accessToken = keychain["accessToken"],
            let deviceId = keychain["deviceId"]
        else {
            return nil
        }
        let credentials = MXCredentials(
            homeServer: homeServer,
            userId: userId,
            accessToken: accessToken
        )
        credentials.deviceId = deviceId
        return credentials
    }
}
