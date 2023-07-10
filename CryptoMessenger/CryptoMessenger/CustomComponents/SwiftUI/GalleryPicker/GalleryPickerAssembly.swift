import SwiftUI

// MARK: - GalleryPickerAssembly

enum GalleryPickerAssembly {

    static func build(selectedImage: Binding<UIImage?>,
                      selectedVideo: Binding<URL?>,
                      sourceType: UIImagePickerController.SourceType = .photoLibrary,
                      galleryContent: GalleryPickerContent = .photos
    ) -> some View {
        let view = GalleryPickerView(selectedImage: selectedImage,
                                     selectedVideo: selectedVideo,
                                     sourceType: sourceType,
                                     galleryContent: galleryContent)
        return view
    }
}
