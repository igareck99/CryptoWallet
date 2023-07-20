import SwiftUI

// MARK: - ProfileCoordinatorProtocol

protocol ProfileFlowCoordinatorProtocol {

    func onSocialList()
    
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent)
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
    
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent) {
        router.galleryPickerFullScreen(selectedImage: selectedImage,
                                       selectedVideo: selectedVideo,
                                       sourceType: sourceType,
                                       galleryContent: galleryContent)
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
