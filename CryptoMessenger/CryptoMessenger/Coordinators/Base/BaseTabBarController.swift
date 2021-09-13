import UIKit

// MARK: - BaseTabBarController

final class BaseTabBarController: UITabBarController {

    // MARK: - Lifecycle

    required init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        setValue(BaseTabBar(frame: tabBar.frame), forKey: "tabBar")
        self.viewControllers = viewControllers
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var prefersHomeIndicatorAutoHidden: Bool { true }
}

// MARK: - BaseTabBarController (UITabBarControllerDelegate)

extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        vibrate()
    }
}
