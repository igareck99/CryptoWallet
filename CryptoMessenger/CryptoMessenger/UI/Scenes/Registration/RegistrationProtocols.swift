import Foundation

// MARK: - RegistrationSceneDelegate

protocol RegistrationSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - RegistrationViewInterface

protocol RegistrationViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
    func setCountryCode(_ country: CountryCodePickerViewController.Country)
}

// MARK: - RegistrationPresentation

protocol RegistrationPresentation: AnyObject {
    func viewDidLoad()
    func handleNextScene(_ phone: String)
    func handleCountryCodeScene()
}
