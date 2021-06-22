import Foundation

// MARK: - UserCredentialsStorage

protocol UserCredentialsStorage: AnyObject {
    var isUserAuthenticated: Bool { get set }
    var token: String { get set }
    var userId: String { get set }
}

// MARK: - UserCredentialsStorageService

final class UserCredentialsStorageService {

    // MARK: - Private Properties

    private let storage: UserCredentialsStorage

    // MARK: - Lifecycle

    init(storage: UserCredentialsStorage = UserDefaultsLayer.storage.auth) {
        self.storage = storage
    }

    // MARK: - Internal Properties

    var isUserAuthenticated: Bool {
        get { storage.isUserAuthenticated }
        set {
            storage.isUserAuthenticated = newValue
        }
    }

    var token: String {
        get { storage.token }
        set {
            storage.token = newValue
        }
    }

    var userId: String {
        get { storage.userId }
        set {
            storage.userId = newValue
        }
    }
}
