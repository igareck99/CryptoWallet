import Foundation
import LocalAuthentication
import UIKit

// MARK: - LocalAuthenticationDelegate

protocol LocalAuthenticationDelegate: AnyObject {
    func didAuthenticate(_ success: Bool)
}

// MARK: - AvailableBiometric

enum AvailableBiometric {

    // MARK: - Types

    case faceID
    case touchID

    // MARK: - Internal Properties

    var name: String? {
        switch self {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        }
    }

    var image: UIImage? {
        switch self {
        case .faceID:
            return R.image.pinCode.faceId()
        case .touchID:
            return R.image.pinCode.touchId()
        }
    }
}

// MARK: - LocalAuthentication

final class LocalAuthentication {

    // MARK: - Internal Properties

    weak var delegate: LocalAuthenticationDelegate?

    // MARK: - Private Properties

    private var authError: NSError?
    private let context = LAContext()
    private let reason = "Authentication is required to continue"

    // MARK: - Lifecycle

    init() {
        context.localizedFallbackTitle = "Please use your pin-code"
        context.touchIDAuthenticationAllowableReuseDuration = 0
    }

    // MARK: - Internal Methods

    func getAvailableBiometrics() -> AvailableBiometric? {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else { return nil }

        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .faceID
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
