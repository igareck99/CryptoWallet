import Foundation

protocol Routerable {
    
    var navigationController: UINavigationController? { get }
    
    func setViewWith(
        _ viewController: UIViewController,
        type: CATransitionType,
        subtype: CATransitionSubtype?,
        isRoot: Bool,
        isNavBarHidden: Bool
    )
}

extension Routerable {
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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        if isRoot {
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.setViewControllers([viewController], animated: false)
        } else {
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
}
