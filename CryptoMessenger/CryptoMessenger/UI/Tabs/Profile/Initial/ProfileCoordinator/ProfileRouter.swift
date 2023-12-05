import Foundation
import SwiftUI

protocol ProfileRouterable {

    func routePath() -> Binding<NavigationPath>

    func presentedItem() -> Binding<BaseSheetLink?>

    func socialList()

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

    func profileDetail(
        coordinator: ProfileFlowCoordinatorProtocol,
        image: Binding<UIImage?>
    )

    func security(coordinator: ProfileFlowCoordinatorProtocol)

    func notifications(coordinator: ProfileFlowCoordinatorProtocol)

    func aboutApp(coordinator: ProfileFlowCoordinatorProtocol)

    func pinCode(pinCodeScreen: PinCodeScreenType)

    func sessions(coordinator: ProfileFlowCoordinatorProtocol)

    func showSettings(result: @escaping GenericBlock<ProfileSettingsMenu>)

    func sheetPicker(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    )

    func blockList()

    func removePresentedItem()

    func clearPath()

    func showPhrase(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    )
}

// MARK: - ChatHistoryRouter

struct ProfileRouter<
    Content: View,
    State: ProfileFlowStatable,
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
        coordinator: ProfileFlowCoordinatorProtocol,
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

    func security(coordinator: ProfileFlowCoordinatorProtocol) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.security(coordinator)
        )
    }

    func notifications(coordinator: ProfileFlowCoordinatorProtocol) {
        state.presentedItem = nil
        state.path.append(
            BaseContentLink.notifications(coordinator)
        )
    }

    func aboutApp(coordinator: ProfileFlowCoordinatorProtocol) {
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

    func sessions(coordinator: ProfileFlowCoordinatorProtocol) {
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
