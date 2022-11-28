import UIKit

// MARK: - RemoteConfigUseCaseAssembly

enum RemoteConfigUseCaseAssembly {

    // MARK: - Static Methods

    static func build() -> RemoteConfigFacade {
		let remoteConfigService = RemoteConfigServiceAssembly.build()
        let remoteConfigUseCase = RemoteConfigUseCase(firebaseService: remoteConfigService)
        return remoteConfigUseCase
    }

    // MARK: - Static Properties

	static var useCase: RemoteConfigFacade {
		RemoteConfigUseCase.shared
	}
}
