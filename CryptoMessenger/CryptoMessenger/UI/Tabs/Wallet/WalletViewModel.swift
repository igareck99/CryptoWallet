import Combine
import SwiftUI

protocol WalletViewModelProtocol: ObservableObject {
    var resources: WalletResourcable.Type { get }
    var viewState: ViewState { get set }
    var cardsList: [WalletInfo] { get set }

    func onAppear()
    func onWalletCardTap(wallet: WalletInfo)
    func showAddSeed()
    func onTransfer(walletIndex: Int)
    func transactionsList(index: Int) -> [TransactionSection]
    func tryToLoadNextTransactions(offset: CGFloat, pageIndex: Int)
}

final class WalletViewModel {
    @Published var transactionList: [TransactionInfo] = []
    @Published var cardsList = [WalletInfo]()
    @Published var canceledImage = UIImage()
    @Published var viewState: ViewState = .empty
    var transactions = [WalletType: [TransactionSection]]()
    var coordinator: WalletCoordinatable?
    let resources: WalletResourcable.Type
    let walletNetworks: WalletNetworkFacadeProtocol
    let coreDataService: CoreDataServiceProtocol
    let keychainService: KeychainServiceProtocol
    let walletModelsFactory: WalletModelsFactoryProtocol.Type
    let keysService: KeysServiceProtocol
    private let apiClient: APIClientManager
    private let matrixUseCase: MatrixUseCaseProtocol
    private let userCredentialsStorage: UserCredentialsStorage
    private var subscriptions = Set<AnyCancellable>()

    init(
        apiClient: APIClientManager = APIClient.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        keysService: KeysServiceProtocol = KeysService(),
        userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared,
        walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        walletModelsFactory: WalletModelsFactoryProtocol.Type = WalletModelsFactory.self,
        resources: WalletResourcable.Type = WalletResources.self
    ) {
        self.apiClient = apiClient
        self.matrixUseCase = matrixUseCase
        self.resources = resources
		self.keychainService = keychainService
		self.keysService = keysService
		self.userCredentialsStorage = userCredentialsStorage
		self.walletNetworks = walletNetworks
		self.coreDataService = coreDataService
        self.walletModelsFactory = walletModelsFactory
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    private func bindInput() {
        keychainService.seedPublisher
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] seed in
                guard let self = self,
                      let newSeed: String = seed,
                      let phrase: String = self.keychainService.secretPhrase,
                      newSeed != phrase,
                      newSeed.isEmpty == false else {
                    debugPrint("SEED EXISTS !!!")
                    return
                }
                Task {
                    await self.updateWallets()
                    await self.updateUserWallet()
                    await MainActor.run {
                        self.objectWillChange.send()
                    }
                }
            }.store(in: &subscriptions)
    }

    // MARK: - Transactions

    func getTransactions() async {
        let walletsAddresses = await getWalletsAddresses()
        let params = walletModelsFactory.makeTransactionsRequestParams(wallets: walletsAddresses)
        let result = await walletNetworks.requestTransactions(params: params)
        guard let walletsTransactions: WalletsTransactionsResponse = result.model?.value else {
            return
        }
        let networkTokens: [NetworkToken] = await coreDataService.getNetworksTokens()
        let sections: TransactionSections = walletModelsFactory.makeTransactions(
            networkTokens: networkTokens,
            model: walletsTransactions
        )
        transactions = sections.sections
        await MainActor.run {
            objectWillChange.send()
        }
    }

    // MARK: - Wallet Addresses

    func getWalletsAddresses() async -> [WalletAddress] {
        let wallets: [WalletNetwork] = await coreDataService.getWalletNetworks()
        let tokens: [NetworkToken] = await coreDataService.getNetworksTokens()
        let addresses: [WalletAddress] = walletModelsFactory.makeWalletsAddresses(
            wallets: wallets,
            tokens: tokens
        )
        return addresses
    }

    private func updateWallet(model: WalletNetwork, address: String) async {
        await coreDataService.updateWalletNetwork(
            id: model.id ?? UUID(),
            lastUpdate: model.lastUpdate ?? "",
            cryptoType: model.cryptoType ?? "",
            name: model.name ?? "",
            derivePath: model.derivePath ?? "",
            address: address,
            contractType: model.contractType,
            decimals: model.decimals,
            symbol: model.symbol ?? "",
            balance: model.balance,
            fiatBalance: ""
        )
    }

    func getAddress() async {
        let params = walletModelsFactory.makeAddressRequestParams(keychainService: keychainService)
        let result = await walletNetworks.requestAddress(params: params)
        guard let addresses: AddressResponse = result.model?.value else { return }
        let savedWallets: [WalletNetwork] = await coreDataService.getWalletNetworks()

        if let address: String = addresses.ethereum?.first?.address,
           let wallet: WalletNetwork = savedWallets
            .first(where: { $0.cryptoType == CryptoType.ethereum.rawValue }) {
            await updateWallet(model: wallet, address: address)
        }

        if let address = addresses.bitcoin?.first?.address,
           let wallet: WalletNetwork = savedWallets
            .first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue }) {
            await updateWallet(model: wallet, address: address)
        }

        if let address = addresses.binance?.first?.address,
           let wallet: WalletNetwork = savedWallets
            .first(where: { $0.cryptoType == CryptoType.binance.rawValue }) {
            await updateWallet(model: wallet, address: address)
        }

        if let address = addresses.aura?.first?.address,
           let wallet: WalletNetwork = savedWallets
            .first(where: { $0.cryptoType == CryptoType.aura.rawValue }) {
            await updateWallet(model: wallet, address: address)
        }
        await updateUserWallet()
        await getBalance()
    }

    // MARK: - Balances

    func getBalance() async {
        let savedWallets: [WalletNetwork] = await coreDataService.getWalletNetworks()
        let savedTokens: [NetworkToken] = await coreDataService.getNetworksTokens()
        let params: BalanceRequestParams = walletModelsFactory.makeBalanceRequestParams(
            wallets: savedWallets,
            networkTokens: savedTokens
        )
        let result = await walletNetworks.requestBalances(params: params)
        guard let balance: BalancesResponse = result.model?.value else { return }
        let balances: [CryptoType: [Balance]] = [
            .ethereum: balance.ethereum,
            .bitcoin: balance.bitcoin,
            .binance: balance.binance,
            .aura: balance.aura
        ]
        for balancePair in balances {
            let cryptoType = balancePair.key
            for balance in balancePair.value {
                if let wallet: WalletNetwork = savedWallets
                    .first(where: {
                        balance.tokenAddress == nil &&
                        balance.accountAddress == $0.address &&
                        $0.cryptoType == cryptoType.rawValue
                    }) {
                    wallet.balance = balance.amount
                    wallet.fiatPrice = balance.fiatPrice ?? .zero
                    await coreDataService.updateWalletNetwork(model: wallet)
                }

                if let token: NetworkToken = savedTokens
                    .first(where: {
                        balance.tokenAddress == $0.address &&
                        $0.network == cryptoType.rawValue
                    }) {
                    token.balance = balance.amount
                    token.fiatPrice = balance.fiatPrice ?? .zero
                    await coreDataService.updateNetworkToken(token: token)
                }
            }
        }
        await updateWalletsFromDB()
        await getTransactions()
    }

    // MARK: - Wallets

    func updateWalletsFromDB() async {
        let wallets: [WalletNetwork] = await coreDataService.getWalletNetworks()
        let tokens: [NetworkToken] = await coreDataService.getNetworksTokens()
        let cards: [WalletInfo] = walletModelsFactory.makeDisplayCards(
            wallets: wallets,
            tokens: tokens
        )
        await MainActor.run {
            viewState = .content
            cardsList = cards
        }
    }

    func updateWallets() async {
        guard let seed: String = keychainService.secretPhrase else {
            // Empty state remains
            await MainActor.run {
                viewState = .empty
                objectWillChange.send()
            }
            return
        }

        let walletsCount: Int = await coreDataService.getWalletNetworksCount()
        if walletsCount > .zero {
            // Show wallets from db
            await MainActor.run {
                viewState = .loading
                objectWillChange.send()
            }
            await updateWalletsFromDB()
            await getTransactions()
            await getBalance()
            return
        }

        // Loading state appears
        await MainActor.run {
            viewState = .loading
            objectWillChange.send()
        }

        // Update wallets in background
        let result = await walletNetworks.requestNetworks()
        guard let walletsResponse: WalletNetworkResponse = result.model?.value else { return }

        let wallets: [WalletNetworkModel] = [
            walletsResponse.binance,
            walletsResponse.bitcoin,
            walletsResponse.ethereum,
            walletsResponse.aura
        ].compactMap { $0 }

        let dbWallets: [WalletNetwork] = await coreDataService.getWalletNetworks()
        var isAddressesAvailable = false
        dbWallets.forEach {
            isAddressesAvailable = (($0.address?.isEmpty == false) && isAddressesAvailable)
        }

        let cryptoTypesDb: Set<CryptoType> = dbWallets
            .reduce(into: Set<CryptoType>(), { partialResult, network in
                if let cryptoType = network.cryptoType,
                   let type = CryptoType(rawValue: cryptoType) {
                    partialResult.insert(type)
                }
            })

        let cryptoTypesNetwork: Set<CryptoType> = wallets
            .reduce(into: Set<CryptoType>(), { partialResult, network in
                if let type = CryptoType(rawValue: network.cryptoType) {
                    partialResult.insert(type)
                }
            })

        // Если нет изменений после последнего создания кошельков
        // то просто обновляем модели в БД
        if cryptoTypesDb == cryptoTypesNetwork && isAddressesAvailable {
            await getBalance()
            await MainActor.run {
                objectWillChange.send()
            }
            return
        }

        // TODO: Переделать на умное обновление БД
        // обновить существующие модели
        // создать новые
        // удалить старые

        await coreDataService.deleteAllWalletNetworks()
        for wallet in wallets {
            await coreDataService.createWalletNetwork(wallet: wallet)
        }

        let savedWallets = await self.coreDataService.getWalletNetworks()
        savedWallets.forEach { wallet in
            guard let type = CryptoType(rawValue: wallet.cryptoType ?? "") else {
                return
            }
            makeKey(type: type, seed: seed, wallet: wallet)
        }
        await getTokens()
    }

    // MARK: - Tokens

    func getTokens() async {
        let wallets: [WalletNetwork] = await coreDataService.getWalletNetworks()
        let cryptoTypes: [CryptoType] = wallets.compactMap {
            guard let cryptoType = $0.cryptoType else { return nil }
            return CryptoType(rawValue: cryptoType)
        }
        let params = NetworkTokensRequestParams(cryptoTypes: cryptoTypes)
        let result = await walletNetworks.requestTokens(params: params)
        guard let networkTokens: NetworkTokensResponse = result.model?.value else {
            return
        }
        let nTokens: [NetworkToken] = await coreDataService.getNetworksTokens()
        let nTokensAddrs: Set<String> = nTokens.compactMap { $0.address }.asSet
        
        let nTokensP: [NetworkTokenPonso] = walletModelsFactory.networkTokenResponseParse(response: networkTokens)
            .filter {
                guard let addrs = $0.networkTokenModel.address else { return false }
                return nTokensAddrs.contains(addrs) == false
            }
        
        for token in nTokensP {
            await coreDataService.createNetworkToken(
                token: token.networkTokenModel,
                network: token.cryptoType.rawValue
            )
        }
        await getAddress()
    }

    // MARK: - Addresses to reward

    func updateUserWallet() async {
        let wallets: [WalletNetwork] = await coreDataService.getWalletNetworks()
        let data: [String: [String: String]] = walletModelsFactory.makeAdressesData(wallets: wallets)
        apiClient.publisher(Endpoints.Wallet.patchAssets(data))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("Error update user wallets adresses  \(error)")
                default:
                    break
                }
            } receiveValue: { response in
                debugPrint("Success update user wallets adresses  \(response)")
            }
            .store(in: &subscriptions)
    }
}
