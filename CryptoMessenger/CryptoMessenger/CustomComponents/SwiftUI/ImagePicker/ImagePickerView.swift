import SwiftUI
import UIKit

// MARK: - ImagePickerView

struct ImagePickerView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Lifecycle

    init(selectedImage: Binding<UIImage?>,
         sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        self._selectedImage = selectedImage
        self.sourceType = sourceType
    }

    // MARK: - Internal Methods

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ImagePickerView>
    ) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<ImagePickerView>
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // MARK: - Private Properties

        private var parent: ImagePickerView

        // MARK: - Life Cycle

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        // MARK: - Internal Methods

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
