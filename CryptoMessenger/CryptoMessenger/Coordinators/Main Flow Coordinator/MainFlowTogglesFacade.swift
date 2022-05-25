import Foundation

// MARK: - MainFlowTogglesFacadeProtocol

protocol MainFlowTogglesFacadeProtocol {
    var isWalletAvailable: Bool { get }
    var isTransactionAvailable: Bool { get }
}

// MARK: - MainFlowTogglesFacade

final class MainFlowTogglesFacade {

    private let remoteConfigUseCase: RemoteConfigUseCaseProtocol

    static let shared = MainFlowTogglesFacade()

    init(
        remoteConfigUseCase: RemoteConfigUseCaseProtocol = RemoteConfigUseCaseAssembly.useCase
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
        let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .wallet)
        let feature = featureConfig?.features[RemoteConfigValues.Wallet.auraTab.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isTransactionAvailable: Bool {
        if !isWalletAvailable {
            return false
        }
        let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .wallet)
        let feature = featureConfig?.features[RemoteConfigValues.Wallet.auraTransaction.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }
}
