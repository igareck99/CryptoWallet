import SwiftUI
import UIKit

// MARK: - GalleryPickerView

struct GalleryPickerView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var sourceType: UIImagePickerController.SourceType
    var galleryContent: GalleryPickerContent
    var onSelectImage: (UIImage?) -> Void
    var onSelectVideo: (URL?) -> Void

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Lifecycle

    init(sourceType: UIImagePickerController.SourceType,
         galleryContent: GalleryPickerContent,
         onSelectImage: @escaping (UIImage?) -> Void,
         onSelectVideo: @escaping (URL?) -> Void) {
        self.sourceType = sourceType
        self.galleryContent = galleryContent
        self.onSelectImage = onSelectImage
        self.onSelectVideo = onSelectVideo
    }

    // MARK: - Internal Methods

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<GalleryPickerView>
    ) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.mediaTypes = GalleryContentType.getTypes(galleryContent)
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<GalleryPickerView>
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // MARK: - Private Properties

        private var parent: GalleryPickerView

        // MARK: - Life Cycle

        init(_ parent: GalleryPickerView) {
            self.parent = parent
        }

        // MARK: - Internal Methods

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            if let image = image {
                parent.onSelectImage(image)
            }
            if let videoURL = videoURL {
                parent.onSelectVideo(videoURL)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
