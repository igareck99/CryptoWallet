import Foundation

// MARK: - MainFlowTogglesFacadeProtocol

protocol MainFlowTogglesFacadeProtocol {
    var isWalletAvailable: Bool { get }
    var isTransactionAvailable: Bool { get }
}

// MARK: - MainFlowTogglesFacade

final class MainFlowTogglesFacade {

    private let remoteConfigUseCase: RemoteConfigToggles
    static let shared = MainFlowTogglesFacade()

    init(
        remoteConfigUseCase: RemoteConfigToggles = RemoteConfigUseCaseAssembly.useCase
    ) {
        self.remoteConfigUseCase = remoteConfigUseCase
        subscribeToConfigUpdate()
    }

    // MARK: - Private Methods

	private func subscribeToConfigUpdate() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(configDidUpdate),
			name: .configDidUpdate,
			object: nil
		)
	}

	@objc func configDidUpdate() {
		let flag = isWalletAvailable
        let transactionFlag = isTransactionAvailable
		debugPrint("RemoteConfig: isWalletAvailable: \(String(describing: flag))")
        debugPrint("RemoteConfig: isTransactionAvailable: \(String(describing: transactionFlag))")

	}
}

// MARK: - MainFlowTogglesFacade(MainFlowTogglesFacadeProtocol)

extension MainFlowTogglesFacade: MainFlowTogglesFacadeProtocol {

    // MARK: - Internal Properties

	var isWalletAvailable: Bool {
		remoteConfigUseCase.isWalletV1Available
    }

    var isTransactionAvailable: Bool {
        if !isWalletAvailable {
            return false
        }
		return remoteConfigUseCase.isTransactionV1Available
    }
}
