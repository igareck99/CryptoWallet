import UIKit

protocol DependenciesServiceProtocol {
	func configureDependencies()
}

final class DependenciesService {}

// MARK: - DependenciesServiceProtocol

extension DependenciesService: DependenciesServiceProtocol {

	func configureDependencies() {
		DependencyContainer {
			Dependency { APIClient() }
			Dependency { Configuration() }
			Dependency { MatrixStore.shared }
			Dependency { CountdownTimer(seconds: PhoneHelper.verificationResendTime) }
			Dependency { ContactsManager() }
		}.build()
	}

}
