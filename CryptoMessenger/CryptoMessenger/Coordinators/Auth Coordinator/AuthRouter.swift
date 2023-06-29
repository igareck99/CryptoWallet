import UIKit

protocol AuhtRouterable: Routerable {
    
    func makeOnboardingViewRoot(delegate: OnboardingSceneDelegate?)
    
    func showRegistrationScene(delegate: RegistrationSceneDelegate?)
    
    func showVerificationScene(delegate: VerificationSceneDelegate?)
    
    func showCountryCodeScene(_ countryCodeDelegate: CountryCodePickerDelegate)
    
}

final class AuhtRouter {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
}

// MARK: - AuhtRouterable

extension AuhtRouter: AuhtRouterable {
    
    func makeOnboardingViewRoot(delegate: OnboardingSceneDelegate?) {
        let view = OnboardingAssembly.build(delegate: delegate)
        let viewController = BaseHostingController(rootView: view)
        setViewWith(viewController)
    }
    
    func showRegistrationScene(delegate: RegistrationSceneDelegate?) {
        let view = RegistrationConfigurator.build(delegate: delegate)
        let viewController = BaseHostingController(rootView: view)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showVerificationScene(delegate: VerificationSceneDelegate?) {
        let view = VerificationConfigurator.build(delegate: delegate)
        let viewController = BaseHostingController(rootView: view)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCountryCodeScene(_ countryCodeDelegate: CountryCodePickerDelegate) {
        let viewController = CountryCodePickerViewController()
        viewController.delegate = countryCodeDelegate
        let nvc = BaseNavigationController(rootViewController: viewController)
        navigationController?.viewControllers.last?.present(nvc, animated: true)
    }
}
