import Foundation

protocol PrivateDataCleanerProtocol {
    func clearWalletPrivateData()
    func clearMatrixPrivateData()
}

final class PrivateDataCleaner {
    static let shared = PrivateDataCleaner()

    private let keychainService: KeychainServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol

    init(
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService.shared
    ) {
        self.keychainService = keychainService
        self.coreDataService = coreDataService
        self.userDefaultsService = userDefaultsService
    }
}

// MARK: - PrivateDataCleanerProtocol

extension PrivateDataCleaner: PrivateDataCleanerProtocol {

    func clearWalletPrivateData() {
        debugPrint("MATRIX DEBUG PrivateDataCleaner clearWalletPrivateData")
        coreDataService.deleteAllWalletNetworks()
        coreDataService.deleteAllNetworksTokens()
        keychainService.removeObject(forKey: .secretPhrase)
        keychainService.removeObject(forKey: .ethereumPrivateKey)
        keychainService.removeObject(forKey: .ethereumPublicKey)
        keychainService.removeObject(forKey: .bitcoinPublicKey)
        keychainService.removeObject(forKey: .bitcoinPrivateKey)
        keychainService.removeObject(forKey: .binancePublicKey)
        keychainService.removeObject(forKey: .binancePrivateKey)
        keychainService.removeObject(forKey: .auraPublicKey)
        keychainService.removeObject(forKey: .auraPrivateKey)
    }

    func clearMatrixPrivateData() {
        debugPrint("MATRIX DEBUG PrivateDataCleaner clearMatrixPrivateData")
        keychainService.removeObject(forKey: .homeServer)
        keychainService.removeObject(forKey: .accessToken)
        keychainService.removeObject(forKey: .apiAccessToken)
        keychainService.removeObject(forKey: .apiRefreshToken)
        keychainService.removeObject(forKey: .walletAccessToken)
        keychainService.removeObject(forKey: .walletRefreshToken)
        keychainService.removeObject(forKey: .deviceId)
        userDefaultsService.removeObject(forKey: .userId)
    }
}
