import Combine
import SwiftUI

// MARK: - WalletViewModel

final class WalletViewModel: ObservableObject {

    // MARK: - Internal Properties

	var transaction: TransactionResult?
	var onTransactionEnd: ((TransactionResult) -> Void)?
	var onTransactionEndHelper: ( @escaping (TransactionResult) -> Void) -> Void

    weak var delegate: WalletSceneDelegate?
    @Published var totalBalance = ""
    @Published var transactionList: [TransactionInfo] = []
	private var transactions = [WalletType: [TransactionSection]]()
    @Published var cardsList = [WalletInfo]()
    @Published var canceledImage = UIImage()
	var viewState: ViewState = .empty

    // MARK: - Private Properties

    @Published private(set) var state: WalletFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<WalletFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<WalletFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    private let userCredentialsStorage: UserCredentialsStorage
	private let walletNetworks: WalletNetworkFacadeProtocol
	private let coreDataService: CoreDataServiceProtocol
	private let keysService: KeysServiceProtocol
	private let keychainService: KeychainServiceProtocol
    private let walletModelsFactory: WalletModelsFactoryProtocol.Type

    // MARK: - Lifecycle

    init(
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        keysService: KeysServiceProtocol = KeysService(),
        userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared,
        walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        walletModelsFactory: WalletModelsFactoryProtocol.Type = WalletModelsFactory.self,
        onTransactionEndHelper: @escaping ( @escaping (TransactionResult) -> Void) -> Void
    ) {
		self.keychainService = keychainService
		self.keysService = keysService
		self.userCredentialsStorage = userCredentialsStorage
		self.walletNetworks = walletNetworks
		self.coreDataService = coreDataService
        self.walletModelsFactory = walletModelsFactory
		self.onTransactionEndHelper = onTransactionEndHelper
        bindInput()
        bindOutput()
        updateWallets()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

	private enum TransactionLoadingState {
		case loading
		case notloading
	}

	private var transactionLoadingState: TransactionLoadingState = .notloading

	func tryToLoadNextTransactions(offset: CGFloat, pageIndex: Int) {

		guard transactionLoadingState == .notloading else { return }

        guard let currentWallet = cardsList[safe: pageIndex],
              let currentTransactions = transactions[currentWallet.walletType],
              let lastTransaction = currentTransactions.last,
              let cryptoType = CryptoType(rawValue: currentWallet.walletType.rawValue)
        else {
            return
        }

		let allTransactionsHeight = CGFloat(currentTransactions.count) * 65
		guard allTransactionsHeight < offset + 420 else { return }

		guard transactionLoadingState == .notloading else { return }

		transactionLoadingState = .loading

        let transaction = WalletTransactions(
            cryptoType: cryptoType,
            address: currentWallet.address,
            date: lastTransaction.info.date
        )

        let params = TransactionsRequestParams(walletTransactions: [transaction])
		walletNetworks.getTransactions(params: params) { [weak self] response in

            guard case let .success(walletsTransactions) = response,
                  let networkTokens: [NetworkToken] = self?.coreDataService.getNetworksTokens(),
                  let transactions = self?.walletModelsFactory
                .makeTransactions(
                    networkTokens: networkTokens,
                    model: walletsTransactions
                ),
                  let transactionsBatch = transactions.sections[currentWallet.walletType]
            else {
                self?.transactionLoadingState = .notloading
                return
            }
            self?.transactions[currentWallet.walletType]?.append(contentsOf: transactionsBatch)

			DispatchQueue.main.async { [weak self] in
				self?.objectWillChange.send()
				self?.transactionLoadingState = .notloading
			}
		}
	}

	private func getWalletsAddresses() -> [WalletAddress] {
        let wallets: [WalletNetwork] = coreDataService.getWalletNetworks()
        let tokens: [NetworkToken] = coreDataService.getNetworksTokens()
        let addresses: [WalletAddress] = walletModelsFactory
            .makeWalletsAddresses(
                wallets: wallets,
                tokens: tokens
            )
		return addresses
	}

	func transactionsList(index: Int) -> [TransactionSection] {
        guard let wallet = cardsList[safe: index],
			  let currentTransactions = transactions[wallet.walletType]
        else {
            return []
        }
		return currentTransactions
	}

	func getTransactions() {

		guard transactionLoadingState == .notloading else { return }
        transactionLoadingState = .loading
		let walletsAddresses = getWalletsAddresses()
        let params = walletModelsFactory.makeTransactionsRequestParams(wallets: walletsAddresses)

		walletNetworks.getTransactions(params: params) { [weak self] response in
            guard let self = self,
                  case let .success(walletsTransactions) = response
            else {
                return
            }

            let networkTokens: [NetworkToken] = self.coreDataService.getNetworksTokens()
            let sections: TransactionSections = self.walletModelsFactory
                .makeTransactions(
                    networkTokens: networkTokens,
                    model: walletsTransactions
                )
            self.transactions = sections.sections
			DispatchQueue.main.async { [weak self] in
				self?.objectWillChange.send()
				self?.transactionLoadingState = .notloading
			}
		}
	}

	func getAddress() {

        let params = walletModelsFactory.makeAddressRequestParams(keychainService: keychainService)
        let group = DispatchGroup()
        group.enter()
		walletNetworks.getAddress(params: params) { [weak self] response in
            guard
                let self = self, case let .success(addresses) = response
            else {
                self?.transactionLoadingState = .notloading
                return
            }

			let savedWallets: [WalletNetwork] = self.coreDataService.getWalletNetworks()

			if let ethereumAddress: String = addresses.ethereum?.first?.address,
			   let wallet: WalletNetwork = savedWallets
				.first(where: { $0.cryptoType == CryptoType.ethereum.rawValue }) {
				   wallet.address = ethereumAddress
				   self.coreDataService.updateWalletNetwork(model: wallet)
			   }

			if let bitcoinAddress = addresses.bitcoin?.first?.address,
			   let wallet: WalletNetwork = savedWallets
				.first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue }) {
				   wallet.address = bitcoinAddress
				   self.coreDataService.updateWalletNetwork(model: wallet)
			   }

            if let binanceAddress = addresses.binance?.first?.address,
               let wallet: WalletNetwork = savedWallets
                .first(where: { $0.cryptoType == CryptoType.binance.rawValue }) {
                   wallet.address = binanceAddress
                   self.coreDataService.updateWalletNetwork(model: wallet)
               }
            group.leave()
		}
        group.notify(queue: .main) {
            self.updateUserWallet()
            self.getBalance()
        }
	}

	func getBalance() {

		let savedWallets: [WalletNetwork] = coreDataService.getWalletNetworks()
        let savedTokens: [NetworkToken] = coreDataService.getNetworksTokens()

        let params: BalanceRequestParams = walletModelsFactory
            .makeBalanceRequestParams(
                wallets: savedWallets,
                networkTokens: savedTokens
            )

		walletNetworks.getBalances(params: params) { [weak self] in

            defer {
                self?.updateWalletsFromDB()
                self?.getTransactions()
            }

			guard let self = self, case let .success(balance) = $0 else { return }

            let balances: [CryptoType: [Balance]] = [
                .ethereum: balance.ethereum,
                .bitcoin: balance.bitcoin,
                .binance: balance.binance
            ]

            balances.forEach { balancePair in
                let cryptoType = balancePair.key
                balancePair.value.forEach { balance in
                    if let wallet: WalletNetwork = savedWallets
                        .first(where: {
                            balance.tokenAddress == nil &&
                            balance.accountAddress == $0.address &&
                            $0.cryptoType == cryptoType.rawValue
                        }) {
                        wallet.balance = balance.amount
                        wallet.fiatPrice = balance.fiatPrice ?? .zero
                        self.coreDataService.updateWalletNetwork(model: wallet)
                    }

                    if let token: NetworkToken = savedTokens
                        .first(where: {
                            balance.tokenAddress == $0.address &&
                            $0.network == cryptoType.rawValue
                        }) {
                        token.balance = balance.amount
                        token.fiatPrice = balance.fiatPrice ?? .zero
                        print("eoiwioweieiowwe")
                        self.coreDataService.updateNetworkToken(token: token)
                    }
                }
            }
		}
	}

	func updateWalletsFromDB() {
		let wallets = coreDataService.getWalletNetworks()
        let tokens = coreDataService.getNetworksTokens()
        let cards: [WalletInfo] = walletModelsFactory.makeDisplayCards(
            wallets: wallets,
            tokens: tokens
        )

		DispatchQueue.main.async {
			self.viewState = .content
			self.cardsList = cards
			self.objectWillChange.send()
		}
	}

	func updateWallets() {

		guard let seed = keychainService.secretPhrase else {
			// Empty state remains
			viewState = .empty
			objectWillChange.send()
			return
		}

		let walletsCount = coreDataService.getWalletNetworksCount()
		if walletsCount > .zero {
			// Show wallets from db
            viewState = .loading
            objectWillChange.send()
			updateWalletsFromDB()
            transactionLoadingState = .notloading
			getTransactions()
			getBalance()
			return
		}

		// Loading state appears
		viewState = .loading
		objectWillChange.send()

		// Update wallets in background
        let group = DispatchGroup()
        group.enter()
		walletNetworks.getNetworks { [weak self] networksResponse in

			guard let self = self, case let .success(walletsResponse) = networksResponse else { return }

            let wallets: [WalletNetworkModel] = [
                walletsResponse.binance,
                walletsResponse.bitcoin,
                walletsResponse.ethereum
            ].compactMap { $0 }

			let dbWallets = self.coreDataService.getWalletNetworks()

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
				self.getBalance()
				return
			}

			// TODO: Переделать на умное обновление БД
			// обновить существующие модели
			// создать новые
			// удалить старые

			self.coreDataService.deleteAllWalletNetworks()

			wallets.forEach { [weak self] in
				guard let self = self else { return }
				self.coreDataService.createWalletNetwork(wallet: $0)
			}
			let savedWallets = self.coreDataService.getWalletNetworks()
			savedWallets.forEach { [weak self] wallet in
                guard let self = self,
                      let cryptoType = wallet.cryptoType,
                      let type = CryptoType(rawValue: cryptoType) else { return }
                switch type {
                case .ethereum:
                    guard let keys = self.keysService.makeEthereumKeys(
                        seed: seed,
                        derivation: wallet.derivePath
                    ) else {
                        // TODO: Обработать неудачное создание ключей
                        return
                    }
                    self.keychainService.set(keys.privateKey, forKey: .ethereumPrivateKey)
                    self.keychainService.set(keys.publicKey, forKey: .ethereumPublicKey)
                case .binance:
                    guard let keys = self.keysService.makeBinanceKeys(
                        seed: seed,
                        derivation: wallet.derivePath
                    ) else {
                        // TODO: Обработать неудачное создание ключей
                        return
                    }
                    self.keychainService.set(keys.privateKey, forKey: .binancePrivateKey)
                    self.keychainService.set(keys.publicKey, forKey: .binancePublicKey)
				case .bitcoin:
                    guard let keys = self.keysService.makeBitcoinKeys(
                        seed: seed,
                        derivation: wallet.derivePath
                    ) else {
                        // TODO: Обработать неудачное создание ключей
                        return
                    }
					self.keychainService.set(keys.privateKey, forKey: .bitcoinPrivateKey)
					self.keychainService.set(keys.publicKey, forKey: .bitcoinPublicKey)
                default:
                    debugPrint("Unlnown result")
				}
			}
            group.leave()
		}
        group.notify(queue: .main) {
            self.getTokens()
        }
	}

    func getTokens() {
        let wallets = self.coreDataService.getWalletNetworks()
        let cryptoTypes: [CryptoType] = wallets.compactMap {
            guard let cryptoType = $0.cryptoType else { return nil }
            return CryptoType(rawValue: cryptoType)
        }
        let params = NetworkTokensRequestParams(cryptoTypes: cryptoTypes)
        let group = DispatchGroup()
        group.enter()
        walletNetworks.getTokens(params: params) { [weak self] result in
            guard let self = self,
                    case let .success(networkTokens) = result else { return }

            walletModelsFactory
                .networkTokenResponseParse(response: networkTokens)
                .forEach {
                    self.coreDataService.createNetworkToken(
                        token: $0.networkTokenModel,
                        network: $0.cryptoType.rawValue
                    )
                }
            group.leave()
        }
        group.notify(queue: .main) {
            self.getAddress()
        }
    }

    // MARK: - Internal Methods

    func send(_ event: WalletFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateWallets()
                    self?.objectWillChange.send()
                case let .onTransactionAddress(selectorTokenIndex, address):
                    self?.delegate?.handleNextScene(.transaction(0, selectorTokenIndex, address))
                case let .onTransactionType(selectorFilterIndex):
                    self?.delegate?.handleNextScene(.transaction(selectorFilterIndex, 0, ""))
                case let .onTransactionToken(selectorTokenIndex):
                    self?.delegate?.handleNextScene(.transaction(0, selectorTokenIndex, ""))
                case .onImportKey:
                    self?.delegate?.handleNextScene(.importKey)
				case .onTransfer(walletIndex: let walletIndex):
					guard let wallet = self?.cardsList[safe: walletIndex] else { return }
					self?.delegate?.handleNextScene(.transfer(wallet: wallet))
				}
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    func updateUserWallet() {
        var wallets = coreDataService.getWalletNetworks()
        var data = walletModelsFactory.makeAdressesData(wallets: wallets)
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
