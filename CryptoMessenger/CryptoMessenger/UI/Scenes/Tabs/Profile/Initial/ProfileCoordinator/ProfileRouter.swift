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
    
    func questions(_ coordinator: ProfileFlowCoordinatorProtocol)
    
    func aboutApp(_ coordinator: ProfileFlowCoordinatorProtocol)
    
    func pinCode(_ pinCodeScreen: PinCodeScreenType)
    
    func sessions(_ coordinator: ProfileFlowCoordinatorProtocol)
}

// MARK: - ChatHistoryRouter

struct ProfileRouter<Content: View, State: ProfileCoordinatorBase>: View {

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
            GalleryPickerClosureAssembly.build(sourceType: sourceType,
                                               galleryContent: galleryContent,
                                               onSelectImage: onSelectImage,
                                               onSelectVideo: onSelectVideo)
            .ignoresSafeArea()
        case let .imageEditor(isShowing: isShowing,
                              image: image,
                              viewModel: viewModel):
            ImageEditorAssembly.build(isShowing: isShowing,
                                      image: image,
                                      viewModel: viewModel)
            .ignoresSafeArea()
        case let .profileDetail(coordinator, image):
            ProfileDetailAssembly.build(coordinator,
                                        image)
        case let .security(coordinator):
            SecurityAssembly.configuredView(coordinator)
        case let .notifications(coordinator):
            NotificationSettingsAssembly.build(coordinator)
        case let .questions(coordinator):
            AnswerAssembly.build(coordinator)
        case let .aboutApp(coordinator):
            AboutAppAssembly.build(coordinator)
        case let .pinCode(screenType):
            PinCodeAssembly.build(screenType: screenType) {
                
            }
        case let .sessions(coordinator):
            SessionAssembly.build(coordinator)
        }
    }
    
    @ViewBuilder
    private func sheetContent(item: ProfileSheetLlink) -> some View {
        switch item {
        default:
            EmptyView()
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
        state.path.append(ProfileContentLlink.galleryPicker(sourceType: sourceType,
                                                            galleryContent: galleryContent,
                                                            onSelectImage: onSelectImage,
                                                            onSelectVideo: onSelectVideo))
    }
    
    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel) {
        state.path.append(ProfileContentLlink.imageEditor(isShowing: isShowing,
                                                          image: image,
                                                          viewModel: viewModel))
    }
    
    func profileDetail(_ coordinator: ProfileFlowCoordinatorProtocol,
                       _ image: Binding<UIImage?>) {
        state.path.append(ProfileContentLlink.profileDetail(coordinator,
                                                            image))
    }
    
    func security(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.path.append(ProfileContentLlink.security(coordinator))
    }
    
    func notifications(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.path.append(ProfileContentLlink.notifications(coordinator))
    }
    
    func questions(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.path.append(ProfileContentLlink.questions(coordinator))
    }
    
    func aboutApp(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.path.append(ProfileContentLlink.aboutApp(coordinator))
    }
    
    func pinCode(_ pinCodeScreen: PinCodeScreenType) {
        state.path.append(ProfileContentLlink.pinCode(pinCodeScreen))
    }
    
    func sessions(_ coordinator: ProfileFlowCoordinatorProtocol) {
        state.path.append(ProfileContentLlink.sessions(coordinator))
    }

}
