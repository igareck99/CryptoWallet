import UIKit

// MARK: - Coordinator

protocol Coordinator: AnyObject {
    var childCoordinators: [String: Coordinator] { get set }
    var navigationController: UINavigationController { get }

    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
    func popViewController(animated: Bool)
    func dismissViewController(animated: Bool, completion: (() -> Void)?)
}

extension Coordinator {

    // MARK: - Internal Methods

    func addChildCoordinator(_ coordinator: Coordinator) {
        let name = String(describing: coordinator)
        guard childCoordinators[name] == nil else { return }

        childCoordinators[name] = coordinator
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        let name = String(describing: coordinator)
        childCoordinators[name] = nil
    }

    func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    func setViewWith(
        _ viewController: UIViewController,
        type: CATransitionType = .fade,
        subtype: CATransitionSubtype? = .none,
        isRoot: Bool = true,
        isNavBarHidden: Bool = true
    ) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = type
        transition.subtype = subtype

        navigationController.setNavigationBarHidden(isNavBarHidden, animated: false)

        if isRoot {
            navigationController.view.layer.add(transition, forKey: nil)
            navigationController.setViewControllers([viewController], animated: false)
        } else {
            navigationController.view.layer.add(transition, forKey: nil)
            navigationController.pushViewController(viewController, animated: false)
        }
    }
}
