import UIKit

// MARK: - BaseViewController

class BaseViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBar()
        setupDefaultNavigationBar()
    }

    // MARK: - Internal Methods

    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setupDefaultNavigationBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.background(.white())
        navigationController?.navigationBar.tintColor(.black())
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor(.white())
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleAttributes([
            .color(.gray()),
            .font(.regular(15))
        ])

        setupBackButton()
    }

    func setupClearNavigationBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = nil
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = false

        setupBackButton()
    }

    // MARK: - Private Methods

    private func setupBackButton() {
        let backImage = R.image.navigation.backButton()
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = nil
        navigationController?.navigationBar.backItem?.backButtonTitle = nil
        navigationController?.navigationItem.backBarButtonItem?.title = ""

        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 0.1),
            .foregroundColor: UIColor.clear
        ]

        BarButtonItemAppearance.setTitleTextAttributes(attributes, for: .normal)
        BarButtonItemAppearance.setTitleTextAttributes(attributes, for: .highlighted)

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
            .setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}
