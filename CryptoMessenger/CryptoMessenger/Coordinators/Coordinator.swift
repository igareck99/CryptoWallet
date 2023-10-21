import SwiftUI
import UIKit

// MARK: - Coordinator

protocol Coordinator: AnyObject {
    var childCoordinators: [String: Coordinator] { get set }

    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
    func startWithView(completion: @escaping RootViewBuilder)
}

extension Coordinator {

    func start() {
        fatalError("Not implemented")
    }

    func startWithView(completion: @escaping RootViewBuilder) {
        fatalError("Not implemented")
    }

    // MARK: - Internal Methods

    func addChildCoordinator(_ coordinator: Coordinator) {
        let name = String(describing: coordinator)
        childCoordinators[name] = coordinator
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        let name = String(describing: coordinator)
        childCoordinators[name] = nil
    }
    
//    let name = String(describing: coordinator).replaceCharacters(characters: "<.", toSeparator: " ").split(separator: " ")[1]
//    let key = String(name)
//    print("slaslaslk  \(key)")
//    childCoordinators[key] = nil
//    print("skasklaslk  \(childCoordinators)")
}
