import SwiftUI
import UIKit

// MARK: - GalleryPickerView

struct GalleryPickerView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    @Binding var selectedImage: UIImage?
    @Binding var selectedVideo: URL?
    var sourceType: UIImagePickerController.SourceType
    var galleryContent: GalleryPickerContent

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Lifecycle

    init(selectedImage: Binding<UIImage?>,
         selectedVideo: Binding<URL?>,
         sourceType: UIImagePickerController.SourceType,
         galleryContent: GalleryPickerContent) {
        self._selectedImage = selectedImage
        self._selectedVideo = selectedVideo
        self.sourceType = sourceType
        self.galleryContent = galleryContent
    }

    // MARK: - Internal Methods

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<GalleryPickerView>
    ) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        if galleryContent == .all {
            controller.mediaTypes = ["public.movie", "public.image"]
        } else {
            controller.mediaTypes = ["public.image"]
        }
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
            parent.selectedImage = image
            parent.selectedVideo = videoURL
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

enum GalleryPickerContent {
    case photos
    case all
}
