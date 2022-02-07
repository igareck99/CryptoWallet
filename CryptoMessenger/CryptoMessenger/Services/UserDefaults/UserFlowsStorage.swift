import Foundation

// MARK: - UserFlowsStorage

protocol UserFlowsStorage {
    var isAuthFlowFinished: Bool { get set }
    var isOnboardingFlowFinished: Bool { get set }
    var isLocalAuth: Bool { get set }
    var isLocalAuthBackgroundAlertShown: Bool { get set }
    var isLocalAuthInBackground: Bool { get set }
    var isPinCodeOn: Bool { get set }
    var isFalsePinCodeOn: Bool { get set }
    var isBiometryOn: Bool { get set }
    var saveToPhotos: Bool { get set }
}

// MARK: - UserFlowsStorageService

final class UserFlowsStorageService {

    // MARK: - Private Properties

    private var storage: UserFlowsStorage

    // MARK: - Lifecycle

    init(storage: UserFlowsStorage = UserDefaultsLayer()) {
        self.storage = storage
    }

    // MARK: - Internal Properties

    var isAuthFlowFinished: Bool {
        get { storage.isAuthFlowFinished }
        set { storage.isAuthFlowFinished = newValue }
    }

    var isOnboardingFlowFinished: Bool {
        get { storage.isOnboardingFlowFinished }
        set { storage.isOnboardingFlowFinished = newValue }
    }

    var isLocalAuth: Bool {
        get { storage.isLocalAuth }
        set { storage.isLocalAuth = newValue }
    }

    var isLocalAuthBackgroundAlertShown: Bool {
        get { storage.isLocalAuthBackgroundAlertShown }
        set { storage.isLocalAuthBackgroundAlertShown = newValue }
    }

    var isLocalAuthInBackground: Bool {
        get { storage.isLocalAuthInBackground }
        set { storage.isLocalAuthInBackground = newValue }
    }

    var isPinCodeOn: Bool {
        get { storage.isPinCodeOn }
        set { storage.isPinCodeOn = newValue }
    }

    var isFalsePinCodeOn: Bool {
        get { storage.isFalsePinCodeOn }
        set { storage.isFalsePinCodeOn = newValue }
    }
    
    var isBiometryOn: Bool {
        get { storage.isBiometryOn }
        set { storage.isBiometryOn = newValue }
    }

    var saveToPhotos: Bool {
        get { storage.saveToPhotos }
        set { storage.saveToPhotos = newValue }
    }
}
