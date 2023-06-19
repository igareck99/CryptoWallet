import SwiftUI

// MARK: - ProfileCoordinatorProtocol

protocol ProfileFlowCoordinatorProtocol {

    func onSocialList()

    func onShowMenuView(_ scene: ProfileSettingsMenu)

    func onProfileDetail(_ image: Binding<UIImage?>)

    func restartFlow()
}

// MARK: - ProfileFlowCoordinator

final class ProfileFlowCoordinator {

    private let router: ProfileSceneDelegate

    // MARK: - Lifecycle

    init(router: ProfileSceneDelegate) {
        self.router = router
    }
}
    
// MARK: - ProfileFlowCoordinator(ProfileFlowCoordinatorProtocol)

extension ProfileFlowCoordinator: ProfileFlowCoordinatorProtocol {

    func onSocialList() {
        router.handleNextScene(.socialList)
    }

    func onShowMenuView(_ scene: ProfileSettingsMenu) {
        switch scene {
        case .personalization:
            router.handleNextScene(.personalization)
        case .security:
            router.handleNextScene(.security)
        case .about:
            router.handleNextScene(.aboutApp)
        case .chat:
            router.handleNextScene(.chatSettings)
        case .questions:
            router.handleNextScene(.faq)
        case .wallet:
            router.handleNextScene(.walletManager)
        case .notifications:
            router.handleNextScene(.notifications)
        default:
            ()
        }
    }

    func onProfileDetail(_ image: Binding<UIImage?>) {
        router.handleNextScene(.profileDetail(image))
    }
    
    func restartFlow() {
        router.restartFlow()
    }
}
