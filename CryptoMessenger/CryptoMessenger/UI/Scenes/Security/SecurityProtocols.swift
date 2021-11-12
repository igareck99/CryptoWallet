import Foundation

// MARK: - SecuritySceneDelegate

protocol SecuritySceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - SecurityViewInterface

protocol SecurityViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - SecurityPresentation

protocol SecurityPresentation: AnyObject {
    var localAuth: LocalAuthentication { get }
    var isLocalAuthBackgroundAlertShown: Bool { get }

    func handleButtonTap(_ isLocalAuth: Bool)
    func checkLocalAuth()
}
