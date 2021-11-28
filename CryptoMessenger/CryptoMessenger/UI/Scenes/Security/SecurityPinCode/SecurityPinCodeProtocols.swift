import Foundation

// MARK: - SecurityPinCodeSceneDelegate

protocol SecurityPinCodeSceneDelegate: AnyObject {
    func handleNextScene()
}

// MARK: - SecurityPinCodeViewInterface

protocol SecurityPinCodeViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
    func setPinCode(_ pinCode: [Int])
}

// MARK: - SecurityPinCodePresentation

protocol SecurityPinCodePresentation: AnyObject {

    func viewDidLoad()
    func setNewPinCode(_ pinCode: String)
    func handleButtonTap(_ isLocalAuth: Bool)
}
