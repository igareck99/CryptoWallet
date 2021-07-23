import Foundation

// MARK: - VerificationSceneDelegate

protocol VerificationSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - VerificationViewInterface

protocol VerificationViewInterface: AnyObject {
    func setPhoneNumber(_ phone: String)
    func showAlert(title: String?, message: String?)
}

// MARK: - VerificationPresentation

protocol VerificationPresentation: AnyObject {
    func viewDidLoad()
    func handleNextScene(_ code: String)
}
