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
        self.keychainService.secretPhrase = ""
        self.coreDataService.deleteAllWalletNetworks()
        self.keychainService.set("", forKey: .ethereumPrivateKey)
        self.keychainService.set("", forKey: .ethereumPublicKey)
        self.keychainService.set("", forKey: .bitcoinPublicKey)
        self.keychainService.set("", forKey: .bitcoinPublicKey)
    }
}

// MARK: - PrivateDataCleanerProtocol

protocol PrivateDataCleanerProtocol {
    func resetPrivateData()
}
