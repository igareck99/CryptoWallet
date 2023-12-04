import SwiftUI

// MARK: - ProfileCoordinatorProtocol

protocol ProfileFlowCoordinatorProtocol {

    func onSocialList()

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    )

    func imageEditor(
        isShowing: Binding<Bool>,
        image: Binding<UIImage?>,
        viewModel: ProfileViewModel
    )

    func settingsScreens(
        type: ProfileSettingsMenu,
        cooordinator: ProfileFlowCoordinatorProtocol,
        image: Binding<UIImage?>
    )

    func pinCode(pinCodeScreen: PinCodeScreenType)

    func sessions()

    func onLogout()

    func showSettings(
        result: @escaping GenericBlock<ProfileSettingsMenu>
    )

    func showFeedPicker(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    )

    func blockList()

    func showPhrase(seed: String)

    func generatePhrase()
}

// MARK: - ProfileFlowCoordinator

final class ProfileFlowCoordinator: Coordinator {
    var childCoordinators = [String: Coordinator]()
    private let router: ProfileRouterable
    private let onlogout: () -> Void

    // MARK: - Lifecycle

    init(
        router: ProfileRouterable,
        onlogout: @escaping () -> Void
    ) {
        self.router = router
        self.onlogout = onlogout
    }
}

// MARK: - ProfileFlowCoordinator(ProfileFlowCoordinatorProtocol)

extension ProfileFlowCoordinator: ProfileFlowCoordinatorProtocol {

    func onLogout() {
        onlogout()
        router.clearPath()
    }

    func onSocialList() {
        router.socialList()
    }

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) {
        router.galleryPickerFullScreen(
            sourceType: sourceType,
            galleryContent: galleryContent,
            onSelectImage: onSelectImage,
            onSelectVideo: onSelectVideo
        )
    }

    func imageEditor(
        isShowing: Binding<Bool>,
        image: Binding<UIImage?>,
        viewModel: ProfileViewModel
    ) {
        router.imageEditor(
            isShowing: isShowing,
            image: image,
            viewModel: viewModel
        )
    }

    func settingsScreens(
        type: ProfileSettingsMenu,
        cooordinator: ProfileFlowCoordinatorProtocol,
        image: Binding<UIImage?>
    ) {
        switch type {
        case .profile:
            router.profileDetail(
                coordinator: cooordinator,
                image: image
            )
        case .security:
            router.security(coordinator: cooordinator)
        case .notifications:
            router.notifications(coordinator: cooordinator)
        case .about:
            router.aboutApp(coordinator: cooordinator)
        // TODO: ????
        // case .personalization:
        default:
            ()
        }
    }

    func pinCode(pinCodeScreen: PinCodeScreenType) {
        router.pinCode(pinCodeScreen: pinCodeScreen)
    }

    func sessions() {
        router.sessions(coordinator: self)
    }

    func showSettings(result: @escaping GenericBlock<ProfileSettingsMenu>) {
        router.showSettings(result: result)
    }

    func showFeedPicker(sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>) {
        router.sheetPicker(sourceType: sourceType)
    }

    func blockList() {
        router.blockList()
    }

    func showPhrase(seed: String) {
        router.showPhrase(
            seed: seed,
            coordinator: self
        )
    }

    func generatePhrase() {
        let createPhraseCoordinator = CreatePhraseCoordinatorAssembly.build(
            path: router.routePath(),
            presentedItem: router.presentedItem()
        ) { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
        }
        addChildCoordinator(createPhraseCoordinator)
        createPhraseCoordinator.start()
    }
}

// MARK: - WatchKeyViewModelDelegate

extension ProfileFlowCoordinator: WatchKeyViewModelDelegate {
    func didFinishShowPhrase() {}
}
