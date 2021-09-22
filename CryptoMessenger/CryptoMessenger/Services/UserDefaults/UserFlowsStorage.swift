import Foundation

// MARK: - UserFlowsStorage

protocol UserFlowsStorage {
    var isAuthFlowFinished: Bool { get set }
    var isOnboardingFlowFinished: Bool { get set }
    var isLocalAuth: Bool { get set }
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
        set {
            storage.isAuthFlowFinished = newValue
        }
    }

    var isOnboardingFlowFinished: Bool {
        get { storage.isOnboardingFlowFinished }
        set {
            storage.isOnboardingFlowFinished = newValue
        }
    }

    var isLocalAuth: Bool {
        get { storage.isLocalAuth }
        set {
            storage.isLocalAuth = newValue
        }
    }
}
