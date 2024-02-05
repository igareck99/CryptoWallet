import Foundation

protocol CoreDataServiceProtocol {

    // MARK: - GET

    func getNetworkTokensWalletsTypes() -> [WalletType]

    func getNetworksTokens() -> [NetworkToken]

    func getNetworkToken(byId id: UUID) -> [NetworkToken]

    func requestNetworkTokensWalletsTypes() async -> [WalletType]

    func requestNetworksTokens() async -> [NetworkToken]

    func requestNetworkToken(byId id: UUID) async -> [NetworkToken]

    // MARK: - CREATE

    @discardableResult
    func createNetworkToken(
        token: NetworkTokenModel,
        network: String
    ) -> NetworkToken?

    @discardableResult
    func createNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) -> NetworkToken?

    @discardableResult
    func makeNetworkToken(
        token: NetworkTokenModel,
        network: String
    ) async -> NetworkToken?

    @discardableResult
    func makeNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) async -> NetworkToken?

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

    @discardableResult
    func renewNetworkToken(token: NetworkToken) async -> NetworkToken?

    @discardableResult
    func renewNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) async -> NetworkToken?

    // MARK: - DELETE

    func deleteNetworkToken(byId id: UUID)

    func deleteAllNetworksTokens()

    func removeNetworkToken(byId id: UUID) async

    @discardableResult
    func removeAllNetworksTokens() async -> Bool

    @discardableResult
    func removeAllNetworksTokens() -> Bool

    // MARK: - WalletNetwork

    func getNetworkWalletsTypes() -> [WalletType]

    func getWalletNetworks() -> [WalletNetwork]

    func getWalletNetworksCount() -> Int

    func requestNetworkWalletsTypes() async -> [WalletType]

    func requestWalletNetworks() async -> [WalletNetwork]

    func requestWalletNetworksCount() async -> Int

    func requestWalletNetwork(byId id: UUID) async -> [WalletNetwork]

    // MARK: - CREATE

    @discardableResult
    func createWalletNetwork(wallet: WalletNetworkModel) -> WalletNetwork?

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
    func makeWalletNetwork(wallet: WalletNetworkModel) async -> WalletNetwork?

    @discardableResult
    func makeWalletNetwork(
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
    ) async -> WalletNetwork?

    // MARK: - UPDATE

    @discardableResult
    func updateWalletNetwork(model: WalletNetwork) -> WalletNetwork?

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
    func renewWalletNetwork(model: WalletNetwork) async -> WalletNetwork?

    @discardableResult
    func renewWalletNetwork(
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
    ) async -> WalletNetwork?

    // MARK: - DELETE

    func deleteWalletNetwork(byId id: UUID)

    @discardableResult
    func deleteAllWalletNetworks() -> Bool

    func removeWalletNetwork(byId id: UUID) async

    @discardableResult
    func removeAllWalletNetworks() async -> Bool
}
