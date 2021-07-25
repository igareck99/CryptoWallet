import Foundation

// MARK: - OnboardingConfigurator

enum OnboardingConfigurator {

    // MARK: - Internal Methods

    static func configuredViewController(delegate: OnboardingSceneDelegate?) -> OnboardingViewController {
        let viewController = OnboardingViewController()
        let presenter = OnboardingPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
