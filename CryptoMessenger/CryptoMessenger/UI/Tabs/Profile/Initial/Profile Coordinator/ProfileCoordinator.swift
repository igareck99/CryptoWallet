import SwiftUI

final class ProfileCoordinator<Router: ProfileRouterable> {
    var childCoordinators = [String: Coordinator]()
    private let router: Router
    private let onlogout: () -> Void

    // MARK: - Lifecycle

    init(
        router: Router,
        onlogout: @escaping () -> Void
    ) {
        self.router = router
        self.onlogout = onlogout
    }
}

// MARK: - ProfileCoordinatable

extension ProfileCoordinator: ProfileCoordinatable {

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
        cooordinator: ProfileCoordinatable,
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
            type: .showSeed,
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

extension ProfileCoordinator: WatchKeyViewModelDelegate {
    func didFinishShowPhrase() {}
}
