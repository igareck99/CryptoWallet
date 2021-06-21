import Foundation

// MARK: Dependency

struct Dependency {

    // MARK: - Internal Properties

    private(set) var value: Any!
    private(set) var name: String

    // MARK: - Private Properties

    private let resolveBlock: () -> Any

    // MARK: - Lifecycle

    init<T>(_ block: @escaping () -> T) {
        resolveBlock = block
        name = String(describing: T.self)
    }

    // MARK: - Internal Methods

    mutating func resolve() {
        value = resolveBlock()
    }
}
