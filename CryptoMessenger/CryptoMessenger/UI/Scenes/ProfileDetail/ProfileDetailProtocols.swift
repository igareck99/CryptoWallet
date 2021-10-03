import Foundation

// MARK: - ProfileDetailSceneDelegate

protocol ProfileDetailSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - ProfileDetailViewInterface

protocol ProfileDetailViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
    func setCountryCode(_ country: CountryCodePickerViewController.Country)
}

// MARK: - ProfileDetailPresentation

protocol ProfileDetailPresentation: AnyObject {
    func viewDidLoad()
    func handleButtonTap()
    func handleCountryCodeScene()
}
