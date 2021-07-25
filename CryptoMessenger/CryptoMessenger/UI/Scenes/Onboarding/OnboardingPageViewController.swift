import UIKit

// MARK: - OnboardingPageViewController

final class OnboardingPageViewController: BaseViewController {

    // MARK: - Types

    typealias OnboardingPage = OnboardingViewController.OnboardingPage

    // MARK: - Internal Properties

    var onNextPageTap: VoidBlock?

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    // MARK: - Private Properties

    private lazy var customView = OnboardingPageView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
    }

    // MARK: - Internal Methods

    func setPage(_ page: OnboardingPage) {
        customView.setPage(page)
    }

    // MARK: - Private Methods

    private func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
