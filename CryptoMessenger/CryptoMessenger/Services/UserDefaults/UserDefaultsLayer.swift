import KeychainAccess
import MatrixSDK
import UIKit
import SwiftUI

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
    private static let accessTokenKey = "accessTokenKey"
    private static let refreshTokenKey = "refreshTokenKey"
    private static let authUserIdKey = "authUserIdKey"
    private static let userPhoneNumberKey = "userPhoneNumberKey"
    private static let isAuthFlowFinishedKey = "isAuthFlowFinishedKey"
    private static let isOnboardingFlowFinishedKey = "isOnboardingFlowFinishedKey"
    private static let isLocalAuthKey = "isLocalAuthKey"
    private static let isLocalAuthBackgroundAlertShownKey = "isLocalAuthBackgroundAlertShownKey"
    private static let isLocalAuthInBackgroundKey = "isLocalAuthInBackgroundKey"
    private static let userPinCodeKey = "userPinCodeKey"
    private static let userFalsePinCodeKey = "userFalsePinCodeKey"
    private static let isFalsePinCodeOnKey = "isFalsePinCodeOnKey"
    private static let socialNetworkList = "socialNetworkList"
    private static let typography = "typography"
    private static let language = "language"
    private static let theme = "theme"
    private static let profileBackgroundImage = "profileBackgroundImage"
    private static let profileObserveState = "profileObserveState"
    private static let telephoneState = "telephoneState"
    private static let lastSeenState = "lastSeenState"
    private static let callsState = "callsState"
    private static let geopositionState = "geopositionState"
    private static let isBiometryOn = "isBiometryOn"
    private static let reserveCopyTime = "reserveCopyTime"
    private static let saveToPhotos = "saveToPhotos"

    // MARK: - Internal Properties

    @UserDefaultSettings(isUserAuthenticatedKey, value: false)
    var isUserAuthenticated: Bool

    @UserDefaultSettings(accessTokenKey, value: "")
    var accessToken: String

    @UserDefaultSettings(refreshTokenKey, value: "")
    var refreshToken: String

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

    @UserDefaultSettings(isFalsePinCodeOnKey, value: false)
    var isFalsePinCodeOn: Bool

    @UserDefaultSettings(userFalsePinCodeKey, value: "")
    var userFalsePinCode: String

    @UserDefaultSettings(socialNetworkList, value: SocialListItem.socialList())
    var socialNetworkList: [SocialListItem]

    @UserDefaultSettings(typography, value: "")
    var typography: String
    
    @UserDefaultSettings(language, value: "")
    var language: String
    
    @UserDefaultSettings(theme, value: "")
    var theme: String
    
    @UserDefaultSettings(profileBackgroundImage, value: -1)
    var profileBackgroundImage: Int
    
    @UserDefaultSettings(telephoneState, value: R.string.localizable.securityContactsAll())
    var telephoneState: String
    
    @UserDefaultSettings(profileObserveState, value: R.string.localizable.securityContactsAll())
    var profileObserveState: String
    
    @UserDefaultSettings(lastSeenState, value: R.string.localizable.securityContactsAll())
    var lastSeenState: String
    
    @UserDefaultSettings(callsState, value: R.string.localizable.securityContactsAll())
    var callsState: String
    
    @UserDefaultSettings(geopositionState, value: R.string.localizable.securityContactsAll())
    var geopositionState: String
    
    @UserDefaultSettings(isBiometryOn, value: true)
    var isBiometryOn: Bool
    
    @UserDefaultSettings(reserveCopyTime, value: R.string.localizable.reserveCopyEveryMonth())
    var reserveCopyTime: String
    
    @UserDefaultSettings(saveToPhotos, value: false)
    var saveToPhotos: Bool

    var userMatrixId: String {
        MXCredentials.from(Keychain(service: "chat.aura.credentials"))?.userId ?? ""
    }
}

// MARK: - UserDefaultsLayer (UserCredentialsStorage)

extension UserDefaultsLayer: UserCredentialsStorage {}

// MARK: - UserDefaultsLayer (UserFlowsStorage)

extension UserDefaultsLayer: UserFlowsStorage {}
