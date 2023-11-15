import Foundation
import SwiftUI

protocol ProfileRouterable {

    func socialList()

    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void)
    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel)
    func profileDetail(_ coordinator: ProfileFlowCoordinatorProtocol,
                       _ image: Binding<UIImage?>)
    func security(_ coordinator: ProfileFlowCoordinatorProtocol)

    func notifications(_ coordinator: ProfileFlowCoordinatorProtocol)

    func aboutApp(_ coordinator: ProfileFlowCoordinatorProtocol)

    func pinCode(_ pinCodeScreen: PinCodeScreenType)

    func sessions(_ coordinator: ProfileFlowCoordinatorProtocol)

    func showSettings(_ result: @escaping GenericBlock<ProfileSettingsMenu>)

    func sheetPicker(_ sourceType: @escaping (UIImagePickerController.SourceType) -> Void)

    func blockList()

    func removePresentedItem()

    func clearPath()
}

// MARK: - ChatHistoryRouter

struct ProfileRouter<Content: View, State: ProfileFlowStatable>: View {

    // MARK: - Internal Properties

    @ObservedObject var state: State
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
                    .sheet(item: $state.presentedItem, content: sheetContent)
            }
            .navigationDestination(
                for: ProfileContentLlink.self,
                destination: linkDestination
            )
        }
    }

    @ViewBuilder
    private func linkDestination(link: ProfileContentLlink) -> some View {
        switch link {
        case .socialList:
            SocialListAssembly.build()
        case let .galleryPicker(sourceType: sourceType,
                                galleryContent: galleryContent,
                                onSelectImage: onSelectImage,
                                onSelectVideo: onSelectVideo):
            GalleryPickerAssembly.build(sourceType: sourceType,
                                        galleryContent: galleryContent,
                                        onSelectImage: onSelectImage,
                                        onSelectVideo: onSelectVideo)
        case let .imageEditor(isShowing: isShowing,
                              image: image,
                              viewModel: viewModel):
            ImageEditorAssembly.build(isShowing: isShowing,
                                      image: image,
                                      viewModel: viewModel)
        case let .profileDetail(coordinator, image):
            ProfileDetailAssembly.build(coordinator,
                                        image)
        case let .security(coordinator):
            SecurityAssembly.configuredView(coordinator)
        case let .notifications(coordinator):
            NotificationSettingsAssembly.build(coordinator)
        case .aboutApp(_):
            AboutAppAssembly.build()
        case let .pinCode(screenType):
            PinCodeAssembly.build(screenType: screenType) {
            }
        case let .sessions(coordinator):
            SessionAssembly.build(coordinator)
        case .blockList:
            BlockedListAssembly.build()
        }
    }

    @ViewBuilder
    private func sheetContent(item: ProfileSheetLlink) -> some View {
        switch item {
        case let .settings(result):
            ProfileSettingsMenuAssembly.build(onSelect: result)
        case let .sheetPicker(sourceType):
            ProfileFeedImageAssembly.build(sourceType)
                    .presentationDetents([.large, .height(337)])
        }
    }
}

// MARK: - ProfileRouter(ProfileRouterable)

extension ProfileRouter: ProfileRouterable {
    func socialList() {
        state.path.append(ProfileContentLlink.socialList)
    }

    func galleryPickerFullScreen(sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent,
                                 onSelectImage: @escaping (UIImage?) -> Void,
                                 onSelectVideo: @escaping (URL?) -> Void) {
        state.presentedItem = nil
        state.path.append(ProfileContentLlink.galleryPicker(sourceType: sourceType,
                                                            galleryContent: galleryContent,
                                                            onSelectImage: onSelectImage,
                                                            onSelectVideo: onSelectVideo))
    }

    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel) {
        state.presentedItem = nil
        state.path.append(ProfileContentLlink.imageEditor(isShowing: isShowing,
                                                          image: image,
                                                          viewModel: viewModel))
    }

    func profileDetail(_ coordinator: ProfileFlowCoordinatorProtocol,
                       _ image: Binding<UIImage?>) {
        state.presentedItem = nil
        state.path.append(ProfileContentLlink.profileDetail(coordinator,
                                                            image))
    }

    func security(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.presentedItem = nil
        state.path.append(ProfileContentLlink.security(coordinator))
    }

    func notifications(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.presentedItem = nil
        state.path.append(ProfileContentLlink.notifications(coordinator))
    }

    func aboutApp(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.presentedItem = nil
        state.path.append(ProfileContentLlink.aboutApp(coordinator))
    }

    func pinCode(_ pinCodeScreen: PinCodeScreenType) {
        state.path.append(ProfileContentLlink.pinCode(pinCodeScreen))
    }

    func sessions(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.path.append(ProfileContentLlink.sessions(coordinator))
    }

    func showSettings(_ result: @escaping GenericBlock<ProfileSettingsMenu>) {
        state.presentedItem = .settings(result)
    }

    func sheetPicker(_ sourceType: @escaping (UIImagePickerController.SourceType) -> Void) {
        state.presentedItem = .sheetPicker(sourceType)
    }

    func blockList() {
        state.path.append(ProfileContentLlink.blockList)
    }

    func removePresentedItem() {
        state.presentedItem = nil
    }
    
    func clearPath() {
        state.path = NavigationPath()
    }
}
