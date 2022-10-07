import Foundation
import LocalAuthentication

typealias AvailableBiometric = BiometryService.BiometryType

protocol BiometryServiceProtocol {
	var biometryType: AvailableBiometric { get }
	
	func checkIfBioMetricAvailable() -> Bool
	func authenticateByBiometry(
		reason: String,
		completion: @escaping (BiometryService.BiometryResult) -> Void
	)
}

final class BiometryService: BiometryServiceProtocol {
	enum BiometryResult {
		case failedByEvaluation // не удалось запустить проверку по биометрии
		case failedByBiometry	// не удалось пройти проверку по биометрии
		case suceeded			// удалось пройти проверку по биометрии
	}

	enum BiometryType {
		case faceID
		case touchID
		case none
	}

	private let context = LAContext()

	var biometryType: BiometryType {
		switch context.biometryType {
		case .faceID:
			return .faceID
		case .touchID:
			return .touchID
		case .none:
			return .none
		@unknown default:
			return .none
		}
	}

	// MARK: - BiometryServiceProtocol

	func checkIfBioMetricAvailable() -> Bool {
		var error: NSError?
		let isBiometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
		return isBiometricAvailable
	}

	func authenticateByBiometry(
		reason: String,
		completion: @escaping (BiometryResult) -> Void
	) {
		var error: NSError?
		guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
			completion(.failedByEvaluation)
			return
		}

		context.evaluatePolicy(
			.deviceOwnerAuthenticationWithBiometrics,
			localizedReason: reason
		) { success, _ in
			if success {
				completion(.suceeded)
				return
			}
			completion(.failedByBiometry)
		}
	}
}
