import Foundation

// MARK: Injectable

@propertyWrapper
struct Injectable<Dependency> {

    // MARK: - Internal Properties

    var dependency: Dependency!

    var wrappedValue: Dependency {
        mutating get {
            self.dependency = dependency ?? DependencyContainer.shared.resolve()
            return dependency
        }

        mutating set {
            dependency = newValue
        }
    }
}
