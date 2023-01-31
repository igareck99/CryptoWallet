import Foundation

// MARK: - PrivateDataCleaner

final class PrivateDataCleaner: PrivateDataCleanerProtocol {

    // MARK: - Static Properties

    static let shared = PrivateDataCleaner()

    // MARK: - Private Properties

    private let keychainService: KeychainServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Lifecycle

    init(keychainService: KeychainServiceProtocol = KeychainService.shared,
         coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.keychainService = keychainService
        self.coreDataService = coreDataService
    }

    // MARK: - Internal Methods

    func resetPrivateData() {
        coreDataService.deleteAllWalletNetworks()
        keychainService.removeObject(forKey: .secretPhrase)
        keychainService.removeObject(forKey: .ethereumPrivateKey)
        keychainService.removeObject(forKey: .ethereumPublicKey)
        keychainService.removeObject(forKey: .bitcoinPublicKey)
        keychainService.removeObject(forKey: .bitcoinPrivateKey)
    }
}

// MARK: - PrivateDataCleanerProtocol

protocol PrivateDataCleanerProtocol {
    func resetPrivateData()
}
