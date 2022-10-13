import Foundation

protocol MatrixUseCaseTogglesProtocol {
	var isRoomsUpdateTimerAvailable: Bool { get }
}

final class MatrixUseCaseToggles {
	private let remoteConfigUseCase: RemoteConfigFacade

	init(
		remoteConfigUseCase: RemoteConfigFacade = RemoteConfigUseCaseAssembly.useCase
	) {
		self.remoteConfigUseCase = remoteConfigUseCase
	}
}

// MARK: - MatrixUseCaseTogglesProtocol

extension MatrixUseCaseToggles: MatrixUseCaseTogglesProtocol {
	var isRoomsUpdateTimerAvailable: Bool {
		remoteConfigUseCase.isRoomsTimerAvailable
	}
}
