import Foundation

// MARK: UserFlowsStorage

protocol UserFlowsStorage: AnyObject {
    var isAuthFlowFinished: Bool { get set }
    var isNewFlowFinished: Bool { get set }
}

// MARK: UserFlowsStorageService

final class UserFlowsStorageService {

    // MARK: - Private Properties

    private let storage: UserFlowsStorage

    // MARK: - Lifecycle

    init(storage: UserFlowsStorage = UserDefaultsLayer.storage.flows) {
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
