import UIKit

protocol DependenciesServiceProtocol {
	func configureDependencies()
}

final class DependenciesService {}

// MARK: - DependenciesServiceProtocol

extension DependenciesService: DependenciesServiceProtocol {

	func configureDependencies() {

		_ = P2PCallUseCase.shared
		_ = RemoteConfigUseCaseAssembly.useCase

		DependencyContainer {
			Dependency { APIClient() }
			Dependency { Configuration() }
			Dependency { MatrixUseCase.shared }
			Dependency { CountdownTimer(seconds: PhoneHelper.verificationResendTime) }
			Dependency { ContactsManager() }
            Dependency { MainFlowTogglesFacade() }
            Dependency { TranslateManagerAPI() }
		}.build()
	}
}
