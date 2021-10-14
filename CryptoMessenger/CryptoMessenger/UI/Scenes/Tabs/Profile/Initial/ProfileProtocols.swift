import UIKit

// MARK: - ProfileSceneDelegate

protocol ProfileSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - ProfileViewInterface

protocol ProfileViewInterface: AnyObject {
    func setPhotos(_ photos: [UIImage?])
    func showAlert(title: String?, message: String?)
}

// MARK: - ProfilePresentation

protocol ProfilePresentation: AnyObject {
    func viewDidLoad()
    func handleButtonTap()
}
