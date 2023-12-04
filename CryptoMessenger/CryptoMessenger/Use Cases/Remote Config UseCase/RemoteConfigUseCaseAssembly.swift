import UIKit

enum RemoteConfigUseCaseAssembly {
    static func build() -> RemoteConfigFacade {
		let remoteConfigService = RemoteConfigServiceAssembly.build()
        let remoteConfigUseCase = RemoteConfigUseCase(firebaseService: remoteConfigService)
        return remoteConfigUseCase
    }

	static var useCase: RemoteConfigFacade {
		RemoteConfigUseCase.shared
	}
}
