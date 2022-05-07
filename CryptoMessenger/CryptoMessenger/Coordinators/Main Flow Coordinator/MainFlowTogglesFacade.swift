import Foundation

protocol MainFlowTogglesFacadeProtocol {
    var isWalletAvailable: Bool { get }
}

final class MainFlowTogglesFacade {
    private let remoteConfigUseCase: RemoteConfigUseCaseProtocol

    init(remoteConfigUseCase: RemoteConfigUseCaseProtocol) {
        self.remoteConfigUseCase = remoteConfigUseCase
    }
}

extension MainFlowTogglesFacade: MainFlowTogglesFacadeProtocol {
    var isWalletAvailable: Bool {
        remoteConfigUseCase.start()
        let featureConfig = remoteConfigUseCase.remoteConfig(forKey: .wallet)
        let feature = featureConfig?.features[WalletModule.ethereumWallet.rawValue]
        let config = feature?.config[VersionModule.second.rawValue]
        return config?.enabled == true
    }
}

enum WalletModule: String {
    case ethereumWallet
}

enum VersionModule: String {
    case first = "1.0"
    case second = "2.0"
}
