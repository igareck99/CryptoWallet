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
	private var transactions: [String: [TransactionSection]] = [String: [TransactionSection]]()
    @Published var cardsList: [WalletInfo] = []
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
			  let currentTransactions = transactions[currentWallet.address] else { return }

		let allTransactionsHeight = CGFloat(currentTransactions.count) * 65

		debugPrint("TrackableScroll allTransactionsHeight: \(allTransactionsHeight)")

		guard allTransactionsHeight < offset + 420 else { return }

		debugPrint("TrackableScroll REQUEST NEXT PAGE")

		guard let wallets = getWalletsAddresses() else { return }

		var params = TransactionsRequestParams(
			ethereum: [],
			bitcoin: []
		)

		if currentWallet.walletType == .bitcoin,
		   let last = currentTransactions.last {
			let bitcoin: [WalletTransactions] = [
				WalletTransactions(address: currentWallet.address, date: last.info.date)
			]
			params.bitcoin = bitcoin
		} else if currentWallet.walletType == .ethereum,
				  let last = currentTransactions.last {
			let ethereum: [WalletTransactions] = [
				WalletTransactions(address: currentWallet.address, date: last.info.date)
			]
			params.ethereum = ethereum
		}

		guard !params.ethereum.isEmpty || !params.bitcoin.isEmpty else { return }

		guard transactionLoadingState == .notloading else { return }

		transactionLoadingState = .loading

		walletNetworks.getTransactions(params: params) { [weak self] response in
			guard case let .success(walletsTransactions) = response,
				  let allTransactions = self?.makeTransactions(model: walletsTransactions),
				  !allTransactions.eth.isEmpty || !allTransactions.btc.isEmpty else {
				self?.transactionLoadingState = .notloading
				return
			}
			self?.transactions[wallets.eth]?.append(contentsOf: allTransactions.eth)
			self?.transactions[wallets.btc]?.append(contentsOf: allTransactions.btc)
			DispatchQueue.main.async { [weak self] in
				self?.objectWillChange.send()
				self?.transactionLoadingState = .notloading
			}
		}
	}

	func tryToLoadNextTransactionsPage(transaction: TransactionSection, pageIndex: Int) {

		guard transactionLoadingState == .notloading else { return }
		guard let wallet = cardsList[safe: pageIndex], let wallets = getWalletsAddresses() else { return }
		var params = TransactionsRequestParams(
			ethereum: [],
			bitcoin: []
		)

		if transaction.info.transactionCoin == .bitcoin,
			let btcLast = transactions[wallets.btc]?.last,
			btcLast.id == transaction.id {
			let bitcoin: [WalletTransactions] = [
				WalletTransactions(address: wallets.btc, date: btcLast.info.date)
			]
			params.bitcoin = bitcoin
		} else if transaction.info.transactionCoin == .ethereum,
			let ethLast = transactions[wallets.eth]?.last,
				  ethLast.id == transaction.id {
			let ethereum: [WalletTransactions] = [
				WalletTransactions(address: wallets.eth, date: ethLast.info.date)
			]
			params.ethereum = ethereum
		}

		guard !params.ethereum.isEmpty || !params.bitcoin.isEmpty else {
			return
		}

		transactionLoadingState = .loading

		walletNetworks.getTransactions(params: params) { [weak self] response in
			guard case let .success(walletsTransactions) = response else { return }
			guard let allTransactions = self?.makeTransactions(model: walletsTransactions) else { return }
			self?.transactions[wallets.eth]?.append(contentsOf: allTransactions.eth)
			self?.transactions[wallets.btc]?.append(contentsOf: allTransactions.btc)
			DispatchQueue.main.async { [weak self] in
				self?.objectWillChange.send()
			}
		}
	}

	private func getWalletsAddresses() -> (eth: String, btc: String)? {
		let dbWallets = coreDataService.getWalletNetworks()

		guard
			let ethereumAddress = dbWallets.first(where: { $0.cryptoType == "ethereum" })?.address,
			let bitcoinAddress = dbWallets.first(where: { $0.cryptoType == "bitcoin" })?.address
		else {
			return nil
		}
		return (eth: ethereumAddress, btc: bitcoinAddress)
	}

	func transactionsList(index: Int) -> [TransactionSection] {
        guard let wallet = cardsList[safe: index],
			  let currentTransactions = transactions[wallet.address] else { return [] }
		return currentTransactions
	}

	func getTransactions() {

		guard transactionLoadingState == .notloading else { return }

		guard let wallets = getWalletsAddresses() else { return }

		transactionLoadingState = .loading

		let ethereum: [WalletTransactions] = [
			WalletTransactions(address: wallets.eth)
		]
		let bitcoin: [WalletTransactions] = [
			WalletTransactions(address: wallets.btc)
		]
		let params = TransactionsRequestParams(
			ethereum: ethereum,
			bitcoin: bitcoin
		)

		walletNetworks.getTransactions(params: params) { [weak self] response in
			guard case let .success(walletsTransactions) = response else { return }
			guard let allTransactions = self?.makeTransactions(model: walletsTransactions) else { return }
			self?.transactions[wallets.eth] = allTransactions.eth
			self?.transactions[wallets.btc] = allTransactions.btc
			DispatchQueue.main.async { [weak self] in
				self?.objectWillChange.send()
				self?.transactionLoadingState = .notloading
			}
		}
	}

	private func makeTransactions(
        model: WalletsTransactionsResponse
    ) -> (eth: [TransactionSection], btc: [TransactionSection])? {

		guard let wallets = getWalletsAddresses() else { return nil }

        let ethTransactions: [TransactionSection] = model.ethereum?.first?.value.map {
			let info = TransactionInfo(
				type: $0.inputs.first?.address == wallets.eth ? .send : .receive,
				date: $0.time ?? "",
				transactionCoin: .ethereum,
				transactionResult: $0.status,
				amount: $0.inputs.first?.value ?? "",
				from: $0.inputs.first?.address ?? ""
			)
			let details = TransactionDetails(
				sender: $0.inputs.first?.address ?? "",
				receiver: $0.outputs.first?.address ?? "",
				block: "\($0.block ?? 0)",
				hash: $0.hash
			)

			return TransactionSection(info: info, details: details)
		} ?? []

        let btcTransactions: [TransactionSection] = model.bitcoin?.first?.value.map {
			let info = TransactionInfo(
				type: $0.inputs.first?.address == wallets.btc ? .send : .receive,
				date: $0.time ?? "",
				transactionCoin: .bitcoin,
				transactionResult: $0.status,
				amount: $0.inputs.first?.value ?? "",
				from: $0.inputs.first?.address ?? ""
			)
			let details = TransactionDetails(
				sender: $0.inputs.first?.address ?? "",
				receiver: $0.outputs.first?.address ?? "",
				block: "\($0.block ?? 0)",
				hash: $0.hash
			)
			return TransactionSection(info: info, details: details)
		} ?? []

		return (eth: ethTransactions, btc: btcTransactions)
	}

	func getAddress() {

        let params = walletModelsFactory.makeAddressRequestParams(keychainService: keychainService)

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

			let updatedWallets = self.coreDataService.getWalletNetworks()
			debugPrint("getAddress updatedWallets: \(updatedWallets)")

			self.getBalance()
		}
	}

	func getBalance() {

		let savedWallets: [WalletNetwork] = coreDataService.getWalletNetworks()
        let savedTokens: [NetworkToken] = coreDataService.getNetworksTokens()

        let params: BalanceRequestParamsV2 = walletModelsFactory.makeBalanceRequestParamsV2(
            wallets: savedWallets,
            networkTokens: savedTokens
        )

		walletNetworks.getBalancesV2(params: params) { [weak self] in

            defer {
                self?.updateWalletsFromDB()
                self?.getTransactions()
            }

			guard let self = self, case let .success(balance) = $0 else { return }

            let balances: [Balance] = balance.ethereum + balance.bitcoin + balance.binance

            balances.forEach { balance in

                if let wallet: WalletNetwork = savedWallets
                    .first(where: { balance.accountAddress == $0.address }) {
                    wallet.balance = balance.amount
                    wallet.fiatPrice = balance.fiatPrice ?? .zero
                    self.coreDataService.updateWalletNetwork(model: wallet)
                }

                if let token: NetworkToken = savedTokens
                    .first(where: { balance.accountAddress == $0.address }) {
                    token.balance = balance.amount
                    token.fiatPrice = balance.fiatPrice ?? .zero
                    self.coreDataService.updateNetworkToken(token: token)
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
        walletNetworks.getTokens(params: params) { [weak self] result in
            guard let self = self, case let .success(networkTokens) = result else { return }

            if let bncTokens = networkTokens.binance {
                bncTokens.forEach {
                    self.coreDataService.createNetworkToken(token: $0, network: CryptoType.binance.rawValue)
                }
            }

            if let btcTokens = networkTokens.bitcoin {
                btcTokens.forEach {
                    self.coreDataService.createNetworkToken(token: $0, network: CryptoType.bitcoin.rawValue)
                }
            }

            if let ethTokens = networkTokens.ethereum {
                ethTokens.forEach {
                    self.coreDataService.createNetworkToken(token: $0, network: CryptoType.ethereum.rawValue)
                }
            }
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
                    self?.updateUserWallet()
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

    private func updateUserWallet() {
        let wallets = coreDataService.getWalletNetworks()
        let data = walletModelsFactory.makeAdressesData(wallets: wallets)

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
