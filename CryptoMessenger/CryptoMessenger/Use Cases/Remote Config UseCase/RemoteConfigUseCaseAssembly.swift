import UIKit

enum RemoteConfigUseCaseAssembly {
    static func build() -> RemoteConfigUseCaseProtocol {
		let remoteConfigService = RemoteConfigServiceAssembly.build()
        let remoteConfigUseCase = RemoteConfigUseCase(firebaseService: remoteConfigService)
        return remoteConfigUseCase
    }

	static var useCase: RemoteConfigUseCaseProtocol {
		RemoteConfigUseCase.shared
	}
}
