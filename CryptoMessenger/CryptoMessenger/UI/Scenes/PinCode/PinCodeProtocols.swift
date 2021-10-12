import Foundation

// MARK: - PinCodeSceneDelegate

protocol PinCodeSceneDelegate: AnyObject {
    func handleNextScene()
}

// MARK: - PinCodeViewInterface

protocol PinCodeViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
    func setPinCode(_ pinCode: [Int])
    func setLocalAuth(_ result: AvailableBiometric?)
}

// MARK: - PinCodePresentation

protocol PinCodePresentation: AnyObject {
    var localAuth: LocalAuthentication { get }
    var isLocalAuthBackgroundAlertShown: Bool { get }

    func viewDidLoad()
    func setNewPinCode(_ pinCode: String)
    func handleButtonTap(_ isLocalAuth: Bool)
    func checkLocalAuth()
}
