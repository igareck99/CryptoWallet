import Foundation

// MARK: - VerificationSceneDelegate

protocol VerificationSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - VerificationViewInterface

protocol VerificationViewInterface: AnyObject {
    func setPhoneNumber(_ phone: String)
    func setCountdownTime(_ time: String)
    func resetCountdownTime()
    func showAlert(title: String?, message: String?)
}

// MARK: - VerificationPresentation

protocol VerificationPresentation: AnyObject {
    func viewDidLoad()
    func handleResendCode()
    func handleNextScene(_ code: String)
}
