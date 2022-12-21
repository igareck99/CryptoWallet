import Combine
import SwiftUI

// MARK: - WalletViewModel

final class WalletViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: WalletSceneDelegate?
    @Published var totalBalance = ""
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
    private let userCredentialsStorage: UserCredentialsStorage
	private let walletNetworks: WalletNetworkFacadeProtocol
	private let coreDataService: CoreDataServiceProtocol
	private let keysService: KeysServiceProtocol
	private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		keysService: KeysServiceProtocol = KeysService(),
		userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared,
		walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
		coreDataService: CoreDataServiceProtocol = CoreDataService.shared
	) {
		self.keychainService = keychainService
		self.keysService = keysService
		self.userCredentialsStorage = userCredentialsStorage
		self.walletNetworks = walletNetworks
		self.coreDataService = coreDataService
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

	func transactionsList(index: Int) -> [TransactionSection] {

		guard let wallet = cardsList[safe: index],
			  let currentTransactions = transactions[wallet.address] else { return [] }
		return currentTransactions
	}

	func getTransactions() {
		let dbWallets = coreDataService.getWalletNetworks()

		guard
			let ethereumAddress = dbWallets.first(where: { $0.cryptoType == "ethereum" })?.address,
			let bitcoinAddress = dbWallets.first(where: { $0.cryptoType == "bitcoin" })?.address
		else {
			return
		}

		let ethereum: [WalletTransactions] = [
			WalletTransactions(address: ethereumAddress, limit: "10")
		]
		let bitcoin: [WalletTransactions] = [
			WalletTransactions(address: bitcoinAddress, limit: "10")
		]
		let params = TransactionsRequestParams(
			ethereum: ethereum,
			bitcoin: bitcoin
		)
		walletNetworks.getTransactions(params: params) { [weak self] response in
			guard case let .success(walletsTransactions) = response else { return }
			self?.makeTransactions(model: walletsTransactions)
		}
	}

	private func makeTransactions(model: WalletsTransactionsResponse) {

		let dbWallets = coreDataService.getWalletNetworks()

		guard
			let ethereumAddress = dbWallets.first(where: { $0.cryptoType == "ethereum" })?.address,
			let bitcoinAddress = dbWallets.first(where: { $0.cryptoType == "bitcoin" })?.address
		else {
			return
		}

		let ethTransactions: [TransactionSection] = model.ethereum.first?.value.map {
			let info = TransactionInfo(
				type: $0.inputs.first?.address == ethereumAddress ? .send : .receive,
				date: $0.time ?? "",
				transactionCoin: .ethereum,
				transactionResult: $0.status,
				amount: $0.inputs.first?.value ?? ""
			)
			let details = TransactionDetails(
				sender: $0.inputs.first?.address ?? "",
				receiver: $0.outputs.first?.address ?? "",
				block: "\($0.block ?? 0)",
				hash: $0.hash
			)

			return TransactionSection(info: info, details: details)
		} ?? []

		transactions[ethereumAddress] = ethTransactions

		let btcTransactions: [TransactionSection] = model.bitcoin.first?.value.map {
			let info = TransactionInfo(
				type: $0.inputs.first?.address == ethereumAddress ? .send : .receive,
				date: $0.time ?? "",
				transactionCoin: .bitcoin,
				transactionResult: $0.status,
				amount: $0.inputs.first?.value ?? ""
			)
			let details = TransactionDetails( // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
				sender: $0.inputs.first?.address ?? "",
				receiver: $0.outputs.first?.address ?? "",
				block: "\($0.block ?? 0)",
				hash: $0.hash
			)
			return TransactionSection(info: info, details: details)
		} ?? []
		transactions[bitcoinAddress] = btcTransactions

		DispatchQueue.main.async {
			self.objectWillChange.send()
		}
	}

	func getAddress(wallets: [WalletNetwork]) {
		guard
			let ethereumPublicKey: String = keychainService[.ethereumPublicKey],
			let bitcoinPublicKey: String = keychainService[.bitcoinPublicKey]
		else {
			return
		}

		let ethereum: [WalletPublic] = [
			WalletPublic(publicKey: ethereumPublicKey)
		]
		let bitcoin: [WalletPublic] = [
			WalletPublic(publicKey: bitcoinPublicKey)
		]
		let params = AddressRequestParams(
			ethereum: ethereum,
			bitcoin: bitcoin
		)
		walletNetworks.getAddress(params: params) { [weak self] response in
			guard let self = self, case let .success(addresses) = response else { return }

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

			let updatedWallets = self.coreDataService.getWalletNetworks()
			debugPrint("getAddress updatedWallets: \(updatedWallets)")

			self.getBalance()
		}
	}

	func getBalance() {

		let savedWallets: [WalletNetwork] = coreDataService.getWalletNetworks()

		guard
			let bitcoinAddress = savedWallets
				.first(where: { $0.cryptoType == "bitcoin" })?.address,
			bitcoinAddress.isEmpty == false,
			let ethereumAddress = savedWallets
				.first(where: { $0.cryptoType == "ethereum" })?.address,
			ethereumAddress.isEmpty == false
		else {
			return
		}

		let ethereum: [WalletBalanceAddress] = [
			WalletBalanceAddress(accountAddress: ethereumAddress)
		]
		let bitcoin: [WalletBalanceAddress] = [
			WalletBalanceAddress(accountAddress: bitcoinAddress)
		]
		let params = BalanceRequestParams(
			ethereum: ethereum,
			bitcoin: bitcoin
		)
		walletNetworks.getBalances(params: params) { [weak self] in

			guard let self = self, case let .success(balance) = $0 else { return }

			// Пока только два типа кошелька

			if let ethereumAmount: String = balance.ethereum.first?.amount,
			   let wallet: WalletNetwork = savedWallets.first(where: { $0.cryptoType == CryptoType.ethereum.rawValue }) {
				wallet.balance = ethereumAmount
				self.coreDataService.updateWalletNetwork(model: wallet)
			}

			if let bitcoinAmount = balance.bitcoin.first?.amount,
			   let wallet: WalletNetwork = savedWallets.first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue }) {
				wallet.balance = bitcoinAmount
				self.coreDataService.updateWalletNetwork(model: wallet)
			}
		}
	}

	func updateWalletsFromDB() {
		let updatedWallets = coreDataService.getWalletNetworks()

		let cards: [WalletInfo] = updatedWallets.map {
			let walletType: WalletType = $0.cryptoType == "ethereum" ? WalletType.ethereum : WalletType.bitcoin
			return WalletInfo(
				decimals: Int($0.decimals),
				walletType: walletType,
				address: $0.address,
				coinAmount: $0.balance ?? "0",
				fiatAmount: "0"
			)
		}

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
			updateWalletsFromDB()
			getTransactions()
			getBalance()
			return
		}

		// Loading state appears
		viewState = .loading
		objectWillChange.send()

		// Update wallets in background
		walletNetworks.getNetworks { [weak self] networks in

			guard let self = self, case let .success(wallets) = networks else { return }

			let dbWallets = self.coreDataService.getWalletNetworks()

			var isAddressesAvailable = false
			dbWallets.forEach {
				isAddressesAvailable = (($0.address.isEmpty == false) && isAddressesAvailable)
			}

			let cryptoTypesDb: Set<CryptoType> = dbWallets
				.reduce(into: Set<CryptoType>(), { partialResult, network in
				if let type = CryptoType(rawValue: network.cryptoType) {
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
				debugPrint("WALLETS isAddressesAvailable TRUE")
				self.getBalance()
				return
			}

			debugPrint("WALLETS isAddressesAvailable FALSE")

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
				guard let self = self else { return }
				guard let type = CryptoType(rawValue: wallet.cryptoType) else { return }
				switch type {
				case .ethereum:
					let keys = self.keysService.makeEthereumKeys(seed: seed)
					self.keychainService.set(keys.privateKey, forKey: .ethereumPrivateKey)
					self.keychainService.set(keys.publicKey, forKey: .ethereumPublicKey)
				case .bitcoin:
					let keys = self.keysService.makeBitcoinKeys(seed: seed)
					self.keychainService.set(keys.privateKey, forKey: .bitcoinPrivateKey)
					self.keychainService.set(keys.publicKey, forKey: .bitcoinPublicKey)
				}
			}
			self.getAddress(wallets: savedWallets)
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
				case .onImportPhrase:
					self?.delegate?.handleNextScene(.phraseManager)
				}
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
