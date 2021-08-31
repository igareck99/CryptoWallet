import SwiftUI
import UIKit

// MARK: - ImagePickerView

struct ImagePickerView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    @Binding var selectedImage: UIImage?
    @SwiftUI.Environment(\.presentationMode) var presentationMode

    // MARK: - Private Properties

    private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    // MARK: - Lifecycle

    init(selectedImage: Binding<UIImage?>) {
        self._selectedImage = selectedImage
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

        // MARK: - Lifecycle

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        // MARK: - Internal Methods

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            parent.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
