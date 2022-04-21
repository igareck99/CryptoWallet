import Foundation

// MARK: - OnboardingConfigurator

enum OnboardingConfigurator {

    // MARK: - Internal Methods

    static func configuredViewController(delegate: OnboardingSceneDelegate?) -> OnboardingViewController {
        let viewController = OnboardingViewController()
		let userFlows = UserDefaultsService.shared
		let presenter = OnboardingPresenter(view: viewController, userFlows: userFlows)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
