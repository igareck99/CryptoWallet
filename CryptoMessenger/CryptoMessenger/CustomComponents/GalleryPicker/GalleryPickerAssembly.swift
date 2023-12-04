import SwiftUI

enum GalleryPickerAssembly {
    static func build(
        sourceType: UIImagePickerController.SourceType = .photoLibrary,
        galleryContent: GalleryPickerContent = .photos,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    ) -> some View {
        let view = GalleryPickerView(sourceType: sourceType,
                                     galleryContent: galleryContent,
                                     onSelectImage: onSelectImage,
                                     onSelectVideo: onSelectVideo
        )
        // TODO: Выпилить это отсюда
            .ignoresSafeArea()
            .toolbar(.hidden,
                     for: .tabBar)
            .toolbar(.hidden,
                     for: .navigationBar)
        return view
    }
}
