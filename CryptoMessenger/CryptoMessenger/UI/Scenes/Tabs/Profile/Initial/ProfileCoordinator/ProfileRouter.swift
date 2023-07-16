import Foundation
import SwiftUI

protocol ProfileRouterable {
    
    func socialList()
    
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent)
    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel)
    func settings(balance: String)
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
        case .galleryPicker(selectedImage: let selectedImage, selectedVideo: let selectedVideo, sourceType: let sourceType, galleryContent: let galleryContent):
            GalleryPickerAssembly.build(selectedImage: selectedImage,
                                        selectedVideo: selectedVideo,
                                        sourceType: sourceType,
                                        galleryContent: galleryContent)
            .ignoresSafeArea()
        case let .imageEditor(isShowing: isShowing,
                          image: image,
                          viewModel: viewModel):
            ImageEditorAssembly.build(isShowing: isShowing,
                                      image: image,
                                      viewModel: viewModel)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func sheetContent(item: ProfileSheetLlink) -> some View {
        switch item {
        case let .settings(balance: balance):
            ProfileSettingsMenuAssembly.build(balance: balance,
                                              onSelect: { value in
                vibrate()
                print("sklasklasklakls  \(value)")
            })
            .background(
                CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                    //.fill(viewModel.resources.background)
            )
        }
    }
}

// MARK: - ProfileRouter(ProfileRouterable)

extension ProfileRouter: ProfileRouterable {
    func socialList() {
        state.path.append(ProfileContentLlink.socialList)
    }
    
    func galleryPickerFullScreen(selectedImage: Binding<UIImage?>,
                                 selectedVideo: Binding<URL?>,
                                 sourceType: UIImagePickerController.SourceType,
                                 galleryContent: GalleryPickerContent) {
        state.path.append(ProfileContentLlink.galleryPicker(selectedImage: selectedImage,
                                                            selectedVideo: selectedVideo,
                                                            sourceType: sourceType,
                                                            galleryContent: galleryContent))
    }
    
    func imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel) {
        state.path.append(ProfileContentLlink.imageEditor(isShowing: isShowing,
                                                          image: image,
                                                          viewModel: viewModel))
    }
    
    func settings(balance: String) {
        state.presentedItem = .settings(balance: balance)
    }
}
