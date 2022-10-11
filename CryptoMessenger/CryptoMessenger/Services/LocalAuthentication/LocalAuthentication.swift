import Foundation
import UIKit

// MARK: - LocalAuthenticationDelegate

protocol LocalAuthenticationDelegate: AnyObject {
    func didAuthenticate(_ success: Bool)
}

// MARK: - LocalAuthentication

final class LocalAuthentication {

    // MARK: - Internal Properties

    weak var delegate: LocalAuthenticationDelegate?
	private let biometryService: BiometryServiceProtocol
	private let sources: BiometrySourcesable.Type

	init(
		biometryService: BiometryServiceProtocol = BiometryService(),
		sources: BiometrySourcesable.Type = BiometrySources.self
	) {
		self.biometryService = biometryService
		self.sources = sources
	}

    // MARK: - Internal Methods

	func getAvailableBiometrics() -> BiometryService.BiometryType {
		guard biometryService.checkIfBioMetricAvailable() else { return .none }
		return biometryService.biometryType
    }

	func biometryAppEnterReasonText() -> String {
		switch biometryService.biometryType {
		case .faceID:
			return sources.faceIdAppEnter
		case .touchID:
			return sources.touchIdAppEnter
		default:
			return ""
		}
	}

	func biometryEnableReasonText() -> String {
		switch biometryService.biometryType {
		case .faceID:
			return sources.faceIdEnable
		case .touchID:
			return sources.touchIdEnable
		default:
			return ""
		}
	}

	func biometryEnableFailureReasonText() -> String {
		switch biometryService.biometryType {
		case .faceID:
			return sources.faceIdEnableFailure
		case .touchID:
			return sources.touchIdEnableFailure
		default:
			return ""
		}
	}

	func authenticateWithBiometrics(reason: String) {
		if biometryService.checkIfBioMetricAvailable() {
			biometryService.authenticateByBiometry(
				reason: reason
			) { [weak self] result in
					DispatchQueue.main.async {
						self?.delegate?.didAuthenticate(result == .suceeded)
					}
				}
		}
	}

	func checkIfBioMetricAvailable() -> Bool {
		biometryService.checkIfBioMetricAvailable()
	}
}
