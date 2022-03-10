import SwiftUI
import UIKit

struct SUImagePickerView: UIViewControllerRepresentable {

    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var image: UIImage?

    func makeCoordinator() -> ImagePickerViewCoordinator { .init(image: $image) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

final class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @Binding var image: UIImage?

    init(image: Binding<UIImage?>) {
        self._image = image
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
    }
}
