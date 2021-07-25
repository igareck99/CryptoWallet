import Foundation

// MARK: - UserFlowsStorage

protocol UserFlowsStorage {
    var isAuthFlowFinished: Bool { get set }
    var isNewFlowFinished: Bool { get set }
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

    var isNewFlowFinished: Bool {
        get { storage.isNewFlowFinished }
        set {
            storage.isNewFlowFinished = newValue
        }
    }
}
