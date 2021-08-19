import Foundation

// MARK: - PinCodeSceneDelegate

protocol PinCodeSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - PinCodeViewInterface

protocol PinCodeViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
    func setLocalAuth(_ result: AvailableBiometrics?)
}

// MARK: - PinCodePresentation

protocol PinCodePresentation: AnyObject {
    func handleButtonTap()
    func checkLocalAuth()
}
