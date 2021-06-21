import Foundation

// MARK: StartViewInterface

protocol StartViewInterface: AnyObject {
    func startActivity(animated: Bool)
    func stopActivity(animated: Bool)
}

// MARK: - StartPresentation

protocol StartPresentation: AnyObject {
    func onViewDidLoad()
}
