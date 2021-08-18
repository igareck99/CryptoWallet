import Foundation
import LocalAuthentication
import UIKit

protocol LocalAuthenticationDelegate: AnyObject {
    func didAuthenticate(_ success: Bool)
}

// MARK: - LocalAuthentication

final class LocalAuthentication {

    // MARK: - Type

    typealias AvailableBiometrics = (name: String, image: UIImage?)

    // MARK: - Internal Properties

    weak var delegate: LocalAuthenticationDelegate?

    // MARK: - Private Properties

    private var authError: NSError?
    private let context = LAContext()
    private let reason = "Authentication is required to continue"

    init() {
        context.localizedFallbackTitle = "Please use your pin-code"
    }

    // MARK: - Internal Methods

    func getAvailableBiometrics() -> AvailableBiometrics? {
        switch context.biometryType {
        case .faceID:
            return (name: "Face ID", image: R.image.pinCode.faceId())
        case .touchID:
            return (name: "TouchID", image: R.image.pinCode.touchId())
        default:
            return nil
        }
    }

    func authenticateWithBiometrics() {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else { return }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                self.delegate?.didAuthenticate(success)
            }
        }
    }
}
