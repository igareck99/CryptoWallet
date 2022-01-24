import Foundation

// MARK: - UserCredentialsStorage

protocol UserCredentialsStorage {
    var isUserAuthenticated: Bool { get set }
    var accessToken: String { get set }
    var refreshToken: String { get set }
    var userId: String { get set }
    var userPhoneNumber: String { get set }
    var userMatrixId: String { get }
    var userPinCode: String { get set }
    var userFalsePinCode: String { get set }
    var socialNetworkList: [SocialListItem] { get set }
}

// MARK: - UserCredentialsStorageService

final class UserCredentialsStorageService {

    // MARK: - Private Properties

    private var storage: UserCredentialsStorage

    // MARK: - Lifecycle

    init(storage: UserCredentialsStorage = UserDefaultsLayer()) {
        self.storage = storage
    }

    // MARK: - Internal Properties

    var isUserAuthenticated: Bool {
        get { storage.isUserAuthenticated }
        set { storage.isUserAuthenticated = newValue }
    }

    var accessToken: String {
        get { storage.accessToken }
        set { storage.accessToken = newValue }
    }

    var refreshToken: String {
        get { storage.refreshToken }
        set { storage.refreshToken = newValue }
    }

    var userId: String {
        get { storage.userId }
        set { storage.userId = newValue }
    }

    var userPhoneNumber: String {
        get { storage.userPhoneNumber }
        set { storage.userPhoneNumber = newValue }
    }

    var userPinCode: String {
        get { storage.userPinCode }
        set { storage.userPinCode = newValue }
    }

    var userFalsePinCode: String {
        get { storage.userPinCode }
        set { storage.userPinCode = newValue }
    }

    var userMatrixId: String { storage.userMatrixId }

    var socialNetworkList: [SocialListItem] {
        get { storage.socialNetworkList }
        set { storage.socialNetworkList = newValue }
    }
}
