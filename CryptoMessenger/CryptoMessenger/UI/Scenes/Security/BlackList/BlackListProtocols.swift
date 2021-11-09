import Foundation

// MARK: - BlackListSceneDelegate

protocol BlackListSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - BlackListViewInterface

protocol BlackListViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - BlackListPresentation

protocol BlackListPresentation: AnyObject {
    func handleButtonTap()
}
