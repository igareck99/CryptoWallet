import AVFoundation
import Foundation
import MobileCoreServices
import Photos
import UIKit

// MARK: - PickerResult

enum PickerResult {
    case success(image: UIImage)
    case error(message: String, settingsUrl: URL?)
}

// MARK: - CameraState

enum CameraState {
    case gallery
    case camera
}

// MARK: - Types

typealias ImageCompletion = (PickerResult) -> Void

// MARK: - ImagePicker (UINavigationControllerDelegate)

final class ImagePicker: NSObject, UINavigationControllerDelegate {

    // MARK: - Private Properties

    private var imagePickerController = UIImagePickerController()
    private var imageCompletion: ImageCompletion?
    private var fromViewController: UIViewController!
    private let settingsUrl = URL(string: UIApplication.openSettingsURLString)

    // MARK: - Internal Properties

    var cameraState: CameraState = .camera

    // MARK: - PermissionState

    enum PermissionState {
        case success
        case error(error: String, openSettings: Bool)
    }

    // MARK: - Lifecycle

    init(fromController: UIViewController, state: CameraState = .camera, completion: ImageCompletion? = nil) {
        super.init()

        self.fromViewController = fromController
        self.imageCompletion = completion
        self.cameraState = state
    }

    // MARK: - Internal Methods

    func setState(_ state: CameraState, completion: ImageCompletion? = nil) {
        self.imageCompletion = completion

        switch state {
        case .camera:
            checkCameraPermission { permissionState in
                switch permissionState {
                case .success:
                    DispatchQueue.main.async {
                        self.showImagePicker(with: .camera)
                    }
                case .error(let message, let openSettings):
                    DispatchQueue.main.async {
                        let url = openSettings ? self.settingsUrl : nil
                        self.imageCompletion?(.error(message: message, settingsUrl: url))
                    }
                }
            }
        case .gallery :
            checkGalleryPermission { permissionState in
                switch permissionState {
                case .success:
                    DispatchQueue.main.async {
                        self.showImagePicker(with: .photoLibrary)
                    }
                case .error(let message, let openSettings):
                    DispatchQueue.main.async {
                        let url = openSettings ? self.settingsUrl : nil
                        self.imageCompletion?(.error(message: message, settingsUrl: url))
                    }
                }
            }
        }
    }

    // MARK: - Private Methods

    private func checkCameraPermission(completion: @escaping ((PermissionState) -> Void)) {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                completion(.success)
            } else {
                completion(.error(error: "Camera is not available", openSettings: false))
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted  in
                if granted {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        completion(.success)
                    } else {
                        completion(.error(error: "Camera is not available", openSettings: false))
                    }
                } else {
                    completion(.error(error: "Enable Camera Permission from the Setting", openSettings: true))
                }
            }
        }
    }

    private func checkGalleryPermission(completion: @escaping ((PermissionState) -> Void)) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            completion(.success)
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        completion(.success)
                    } else {
                        completion(.error(error: "PhotoLibrary is not available", openSettings: false))
                    }
                } else {
                    completion(.error(error: "Photo Library permission is not enable", openSettings: true))
                }
            }
        }
    }

    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.allowsEditing = false
        imagePickerController.modalPresentationStyle = .overFullScreen
        imagePickerController.delegate = self
        fromViewController.present(imagePickerController, animated: true)
    }
}

// MARK: - ImagePicker (UIImagePickerControllerDelegate)

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        var pickedImage = UIImage()

        switch picker.sourceType {
        case .camera:
            guard let image = info[.originalImage] as? UIImage else {
                picker.dismiss(animated: true)
                return
            }
            pickedImage = image
        case .savedPhotosAlbum, .photoLibrary:
            guard let image = info[.originalImage] as? UIImage else {
                picker.dismiss(animated: true)
                return
            }
            pickedImage = image
        default:
            picker.dismiss(animated: true)
            return
        }

        imageCompletion?(.success(image: pickedImage))
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
