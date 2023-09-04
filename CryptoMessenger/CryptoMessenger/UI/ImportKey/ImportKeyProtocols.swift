import Foundation

// MARK: - ImportKeySceneDelegate

protocol ImportKeySceneDelegate: AnyObject {
    func handleNextScene()
    var resources: ImportKeyResourcable.Type { get }
}
