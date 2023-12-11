import Foundation
import SwiftUI

struct ProfileRouter<
    Content: View,
    State: ProfileRouterStatable,
    Factory: ViewsBaseFactoryProtocol
>: View {

    // MARK: - Internal Properties

    @ObservedObject var state: State
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(
                    item: $state.presentedItem,
                    content: factory.makeSheet
                )
                .navigationDestination(
                    for: BaseContentLink.self,
                    destination: factory.makeContent
                )
        }
    }
}

// MARK: - ProfileRouter(ProfileRouterable)

extension ProfileRouter: ProfileRouterable {

    func routePath() -> Binding<NavigationPath> {
        $state.path
    }

    func presentedItem() -> Binding<BaseSheetLink?> {
        $state.presentedItem
    }

    func showPhrase(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    ) {
        state.path.append(
            BaseContentLink.showPhrase(
                seed: seed,
                type: type,
                coordinator: coordinator
            )
        )
    }

    func socialList() {
        state.path.append(
            BaseContentLink.socialList
        )
    }

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.galleryPicker(
                sourceType: sourceType,
                galleryContent: galleryContent,
                onSelectImage: onSelectImage,
                onSelectVideo: onSelectVideo
            )
        )
    }

    func imageEditor(
        isShowing: Binding<Bool>,
        image: Binding<UIImage?>,
        viewModel: ProfileViewModel
    ) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.imageEditor(
                isShowing: isShowing,
                image: image,
                viewModel: viewModel
            )
        )
    }

    func profileDetail(
        coordinator: ProfileCoordinatable,
        image: Binding<UIImage?>
    ) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.profileDetail(
                coordinator,
                image
            )
        )
    }

    func security(coordinator: ProfileCoordinatable) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.security(coordinator)
        )
    }

    func notifications(coordinator: ProfileCoordinatable) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.notifications(coordinator)
        )
    }

    func aboutApp(coordinator: ProfileCoordinatable) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.aboutApp(coordinator)
        )
    }

    func pinCode(pinCodeScreen: PinCodeScreenType) {
        state.path.append(
            BaseContentLink.pinCode(pinCodeScreen)
        )
    }

    func sessions(coordinator: ProfileCoordinatable) {
        state.path.append(
            BaseContentLink.sessions(coordinator)
        )
    }

    func showSettings(result: @escaping GenericBlock<ProfileSettingsMenu>) {
        state.presentedItem = .settings(result)
    }

    func sheetPicker(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    ) {
        state.presentedItem = .sheetPicker(sourceType)
    }

    func blockList() {
        state.path.append(
            BaseContentLink.blockList
        )
    }

    func removePresentedItem() {
        state.presentedItem = nil
    }

    func clearPath() {
        state.path = NavigationPath()
    }
}