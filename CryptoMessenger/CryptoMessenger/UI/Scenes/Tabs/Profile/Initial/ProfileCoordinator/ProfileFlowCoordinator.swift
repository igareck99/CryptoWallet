import SwiftUI

// MARK: - ProfileCoordinatorProtocol

protocol ProfileFlowCoordinatorProtocol {

    func onSocialList()
    
    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void)
    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel)
    
    func settingsScreens(_ type: ProfileSettingsMenu,
                         _ cooordinator: ProfileFlowCoordinatorProtocol,
                         _ image: Binding<UIImage?>)
    func pinCode(_ pinCodeScreen: PinCodeScreenType)
    func sessions(_ coordinator: ProfileFlowCoordinatorProtocol)
}

// MARK: - ProfileFlowCoordinator

final class ProfileFlowCoordinator {

    private let router: ProfileRouterable

    // MARK: - Lifecycle

    init(router: ProfileRouterable) {
        self.router = router
    }
}
    
// MARK: - ProfileFlowCoordinator(ProfileFlowCoordinatorProtocol)

extension ProfileFlowCoordinator: ProfileFlowCoordinatorProtocol {

    func onSocialList() {
        router.socialList()
    }
    
    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void) {
        router.galleryPickerFullScreen(sourceType: sourceType,
                                       galleryContent: galleryContent,
                                       onSelectImage: onSelectImage,
                                       onSelectVideo: onSelectVideo)
    }

    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel) {
        router.imageEditor(isShowing: isShowing,
                           image: image,
                           viewModel: viewModel)
    }

    func settingsScreens(_ type: ProfileSettingsMenu,
                         _ cooordinator: ProfileFlowCoordinatorProtocol,
                         _ image: Binding<UIImage?>) {
        switch type {
        case .profile:
            router.profileDetail(cooordinator,
                                 image)
        case .security:
            router.security(cooordinator)
        case .notifications:
            router.notifications(cooordinator)
        case .questions:
            router.questions(cooordinator)
        case .about:
            router.aboutApp(cooordinator)
        default:
            ()
        }
    }
    
    func pinCode(_ pinCodeScreen: PinCodeScreenType) {
        router.pinCode(pinCodeScreen)
    }
    
    func sessions(_ coordinator: ProfileFlowCoordinatorProtocol) {
        router.sessions(coordinator)
    }
}
