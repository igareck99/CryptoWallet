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

    private var reason = ""

    // MARK: - Internal Methods

    func getAvailableBiometrics() -> AvailableBiometric? {
        var error: NSError?
        let context = LAContext()

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return nil }

        switch context.biometryType {
        case .faceID:
            reason = "Provide Face ID"
            return .faceID
        case .touchID:
            reason = "Provide Touch ID"
            return .faceID
        default:
            return nil
        }
    }

    func checkIfBioMetricAvailable() -> Bool {
        var error: NSError?
        let laContext = LAContext()

        let isBiometricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            print(error.localizedDescription)
        }

        return isBiometricAvailable
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = 0
        context.localizedFallbackTitle = "Please use your pin-code"

        if checkIfBioMetricAvailable() {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    self.delegate?.didAuthenticate(success)
                }
            }
        }
    }
}
