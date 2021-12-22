import UIKit

// MARK: - ProfileBackgroundSceneDelegate

protocol ProfileBackgroundSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - ProfileBackgroundViewInterface

protocol ProfileBackgroundViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
    func setPhotos(_ photos: [UIImage?])
}

// MARK: - ProfileBackgroundPresentation

protocol ProfileBackgroundPresentation: AnyObject {
    func handleButtonTap()
    func viewDidLoad()
}
