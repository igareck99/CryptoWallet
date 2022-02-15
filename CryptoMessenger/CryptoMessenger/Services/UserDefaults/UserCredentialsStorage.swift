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
    var typography: String { get set }
    var language: String { get set }
    var theme: String { get set }
    var profileBackgroundImage: Int { get set }
    var telephoneState: String { get set }
    var profileObserveState: String { get set }
    var lastSeenState: String { get set }
    var callsState: String { get set }
    var geopositionState: String { get set }
    var reserveCopyTime: String { get set }
    var facebook: String { get set }
    var instagram: String { get set }
    var website: String { get set }
    var twitter: String { get set }
    var VK: String { get set }

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

    var typography: String {
        get { storage.typography }
        set { storage.typography = newValue }
    }

    var language: String {
        get { storage.language }
        set { storage.language = newValue }
    }

    var theme: String {
        get { storage.theme }
        set { storage.theme = newValue }
    }

    var profileBackgroundImage: Int {
        get { storage.profileBackgroundImage }
        set { storage.profileBackgroundImage = newValue }
    }

    var telephoneState: String {
        get { storage.telephoneState }
        set { storage.telephoneState = newValue }
    }

    var profileObserveState: String {
        get { storage.profileObserveState }
        set { storage.profileObserveState = newValue }
    }

    var lastSeenState: String {
        get { storage.lastSeenState }
        set { storage.lastSeenState = newValue }
    }

    var callsState: String {
        get { storage.callsState }
        set { storage.callsState = newValue }
    }

    var geopositionState: String {
        get { storage.geopositionState }
        set { storage.geopositionState = newValue }
    }
    
    var reserveCopyTime: String {
        get { storage.reserveCopyTime }
        set { storage.reserveCopyTime = newValue }
    }
    
    var facebook: String {
        get { storage.facebook }
        set { storage.facebook = newValue }
    }
    
    var instagram: String {
        get { storage.instagram }
        set { storage.instagram = newValue }
    }
    
    var website: String {
        get { storage.website }
        set { storage.website = newValue }
    }
    
    var twitter: String {
        get { storage.twitter }
        set { storage.twitter = newValue }
    }
    
    var VK: String {
        get { storage.VK }
        set { storage.VK = newValue }
    }

}
