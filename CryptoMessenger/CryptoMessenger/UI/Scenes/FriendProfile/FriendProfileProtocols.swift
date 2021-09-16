import Foundation

// MARK: - FriendProfileSceneDelegate

protocol FriendProfileSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - FriendProfileViewInterface

protocol FriendProfileViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - FriendProfilePresentation

protocol FriendProfilePresentation: AnyObject {
    func handleButtonTap()
}
