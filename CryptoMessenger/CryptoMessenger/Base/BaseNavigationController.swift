import UIKit

// MARK: - BaseNavigationController

class BaseNavigationController: UINavigationController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Internal Methods

    func makeNotTranslucent() {
//        navigationBar.isTranslucent = true
    }

    func removeBorder() {
//        navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
