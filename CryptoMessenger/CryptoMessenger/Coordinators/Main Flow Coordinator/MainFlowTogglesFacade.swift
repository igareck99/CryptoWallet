import Foundation

protocol MainFlowTogglesFacadeProtocol {
    var isWalletAvailable: Bool { get }
    var isTranslateAvailable: Bool { get }

}

final class MainFlowTogglesFacade {
    private let remoteConfigUseCase: RemoteConfigUseCaseProtocol

    init(remoteConfigUseCase: RemoteConfigUseCaseProtocol) {
        self.remoteConfigUseCase = remoteConfigUseCase
		subscribeToConfigUpdate()
    }

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
		debugPrint("RemoteConfig: isWalletAvailable: \(String(describing: flag))")
	}
}

extension MainFlowTogglesFacade: MainFlowTogglesFacadeProtocol {
    var isWalletAvailable: Bool {
		let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .wallet)
		let feature = featureConfig?.features[RemoteConfigValues.Wallet.auraTab.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
    }
    var isTranslateAvailable: Bool {
        let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .wallet)
        let feature = featureConfig?.features[RemoteConfigValues.Wallet.auraTab.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }
}

enum WalletModule: String {
    case ethereumWallet
}

enum TranslateModule: String {
    case translateOption
}

enum VersionModule: String {
    case first = "1.0"
    case second = "2.0"
}
