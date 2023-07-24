import SwiftUI

// MARK: - GalleryPickerClosureAssembly

enum GalleryPickerClosureAssembly {

    static func build(sourceType: UIImagePickerController.SourceType = .photoLibrary,
                      galleryContent: GalleryPickerContent = .photos,
                      onSelectImage: @escaping (UIImage?) -> Void,
                      onSelectVideo: @escaping (URL?) -> Void
                      
    ) -> some View {
        let view = GalleryPickerClosureView(sourceType: sourceType,
                                            galleryContent: galleryContent,
                                            onSelectImage: onSelectImage,
                                            onSelectVideo: onSelectVideo
        )
        return view
    }
}
