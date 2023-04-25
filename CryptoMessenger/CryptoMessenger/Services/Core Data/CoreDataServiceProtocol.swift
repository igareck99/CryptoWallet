import Foundation

// MARK: - CoreDataServiceProtocol

protocol CoreDataServiceProtocol {

    // MARK: - WalletNetwork

    // MARK: - GET

    func getNetworkWalletsTypes() -> [WalletType]

    func getWalletNetworks() -> [WalletNetwork]

    func getWalletNetworksCount() -> Int

    func getWalletNetwork(byId id: UUID) -> WalletNetwork?

    // MARK: - CREATE

    @discardableResult
    func createWalletNetwork(
        id: UUID,
        lastUpdate: String,
        cryptoType: String,
        name: String,
        derivePath: String,
        // Token
        address: String,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        // Other
        balance: String?,
        fiatBalance: String?
    ) -> WalletNetwork?

    @discardableResult
    func createWalletNetwork(wallet: WalletNetworkModel) -> WalletNetwork?

    // MARK: - UPDATE

    func updaterForWalletNetworks(fetchResultClosure: @escaping FetchResultClosure)

    @discardableResult
    func updateWalletNetwork(
        id: UUID,
        lastUpdate: String,
        cryptoType: String,
        name: String,
        derivePath: String,
        // Token
        address: String,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        // Other
        balance: String?,
        fiatBalance: String?
    ) -> WalletNetwork?

    @discardableResult
    func updateWalletNetwork(model: WalletNetwork) -> WalletNetwork?

    // MARK: - DELETE

    func deleteWalletNetwork(byId id: UUID)

    func deleteAllWalletNetworks()

    // MARK: - NetworkToken

    // MARK: - GET
    
    func getNetworkTokensWalletsTypes() -> [WalletType]
    
    func getNetworksTokens() -> [NetworkToken] 

    func getNetworkToken(byId id: UUID) -> NetworkToken?

    // MARK: - CREATE

    @discardableResult
    func createNetworkToken(token: NetworkTokenModel, network: String) -> NetworkToken?

    func createNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) -> NetworkToken?

    // MARK: - UPDATE

    @discardableResult
    func updateNetworkToken(token: NetworkToken) -> NetworkToken?

    @discardableResult
    func updateNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) -> NetworkToken?
    
    // MARK: - DELETE

    func deleteNetworkToken(byId id: UUID)

    func deleteAllNetworksTokens()
}
