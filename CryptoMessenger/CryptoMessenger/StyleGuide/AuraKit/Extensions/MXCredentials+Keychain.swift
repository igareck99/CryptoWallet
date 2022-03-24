import KeychainAccess
import MatrixSDK

// MARK: - KeychainKey

private enum KeychainKey: String {

    // MARK: - Types

    case homeServer
    case userId
    case accessToken
    case deviceId
}

// MARK: - Keychain ()

private extension Keychain {

    // MARK: - Subscript

    subscript(keychainKey: KeychainKey) -> String? {
        get { try? get(keychainKey.rawValue) }

        set {
            let key = keychainKey.rawValue
            if let value = newValue {
                do {
                    try set(value, key: key)
                } catch {}
            } else {
                do {
                    try remove(key)
                } catch {}
            }
        }
    }
}

// MARK: - MXCredentials ()

extension MXCredentials {

    // MARK: - Internal Methods

    func save(to keychain: Keychain) {
        guard
            let homeServer = homeServer,
            let userId = userId,
            let accessToken = accessToken,
            let deviceId = deviceId
        else {
            return
        }
        keychain[.homeServer] = homeServer
        keychain[.userId] = userId
        keychain[.accessToken] = accessToken
        keychain[.deviceId] = deviceId
    }

    func clear(from keychain: Keychain) {
        keychain[.homeServer] = nil
        keychain[.userId] = nil
        keychain[.accessToken] = nil
        keychain[.deviceId] = nil
    }

    // MARK: - Static Methods

    static func from(_ keychain: Keychain) -> MXCredentials? {
        guard
            let homeServer = keychain[.homeServer],
            let userId = keychain[.userId],
            let accessToken = keychain[.accessToken],
            let deviceId = keychain[.deviceId]
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
