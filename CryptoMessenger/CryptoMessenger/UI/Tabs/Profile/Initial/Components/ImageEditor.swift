import SwiftUI
import Mantis

struct ImageEditor: UIViewControllerRepresentable {
    typealias Coordinator = ImageEditorCoordinator
    @Binding var theimage: UIImage?
    @Binding var isShowing: Bool
    @StateObject var viewModel: ProfileViewModel

    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $theimage,
                                      isShowing: $isShowing,
                                      viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) {
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ImageEditor>
    ) -> Mantis.CropViewController {
        let Editor = Mantis.cropViewController(image: theimage ?? UIImage())
        Editor.delegate = context.coordinator
        return Editor
    }
}

class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {

    @Binding var theimage: UIImage?
    @Binding var isShowing: Bool
    var viewModel: ProfileViewModel

    init(image: Binding<UIImage?>, isShowing: Binding<Bool>, viewModel: ProfileViewModel) {
        _theimage = image
        _isShowing = isShowing
        self.viewModel = viewModel
    }

    func cropViewControllerDidCrop(_ cropViewController: CropViewController,
                                   cropped: UIImage,
                                   transformation: Transformation,
                                   cropInfo: CropInfo) {
        viewModel.changedImage = cropped
        isShowing = false
    }

    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController,
                                         original: UIImage) {
    }

    func cropViewControllerDidCancel(_ cropViewController: CropViewController,
                                     original: UIImage) {
        isShowing = false
    }

    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
    }

    func cropViewControllerDidEndResize(_ cropViewController: CropViewController,
                                        original: UIImage, cropInfo: CropInfo) {
    }
}
