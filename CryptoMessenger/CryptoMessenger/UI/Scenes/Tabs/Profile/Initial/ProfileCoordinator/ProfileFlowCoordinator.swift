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
    
    func settings(balance: String)
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
    
    func settings(balance: String) {
        router.settings(balance: balance)
    }
}
