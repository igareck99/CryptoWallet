import Combine
import SwiftUI

// MARK: - WalletViewModel

final class WalletViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: WalletSceneDelegate?
    @Published var totalBalance = ""
    @Published var transactionList: [TransactionInfo] = []
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

	func getAddress(wallets: [WalletNetwork]) {
		guard let ethereumPublicKey: String = keychainService[.ethereumPublicKey],
		   let bitcoinPublicKey: String = keychainService[.bitcoinPublicKey] else { return }

		let params = AddressRequestParams(
			ethereumPublicKey: ethereumPublicKey,
			bitcoinPublicKey: bitcoinPublicKey
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

		guard let bitcoinAddress = savedWallets
			.first(where: { $0.cryptoType == "bitcoin" })?.address,
			  bitcoinAddress.isEmpty == false,
			  let ethereumAddress = savedWallets
			.first(where: { $0.cryptoType == "ethereum" })?.address,
			  ethereumAddress.isEmpty == false else { return }

		let params = BalanceRequestParams(
			ethereumAddress: ethereumAddress,
			bitcoinAddress: bitcoinAddress
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

			self.updateWalletsFromDB()
		}
	}

	func updateWalletsFromDB() {
		let updatedWallets = coreDataService.getWalletNetworks()

		let cards: [WalletInfo] = updatedWallets.map {
			let walletType: WalletType = $0.cryptoType == "ethereum" ? WalletType.ethereum : WalletType.bitcoin
			return WalletInfo(walletType: walletType, address: $0.address, coinAmount: $0.balance ?? "0", fiatAmount: "0")
		}

		if Thread.isMainThread {
			viewState = .content
			cardsList = cards
			objectWillChange.send()
		} else {
			DispatchQueue.main.async {
				self.viewState = .content
				self.cardsList = cards
				self.objectWillChange.send()
			}
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
                    self?.updateTransactionsListData()
                    self?.objectWillChange.send()
                case let .onTransactionAddress(selectorTokenIndex, address):
                    self?.delegate?.handleNextScene(.transaction(0, selectorTokenIndex, address))
                case let .onTransactionType(selectorFilterIndex):
                    self?.delegate?.handleNextScene(.transaction(selectorFilterIndex, 0, ""))
                case let .onTransactionToken(selectorTokenIndex):
                    self?.delegate?.handleNextScene(.transaction(0, selectorTokenIndex, ""))
                case .onImportKey:
                    self?.delegate?.handleNextScene(.importKey)
                case .onTransfer:
                    self?.delegate?.handleNextScene(.transfer)
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

    private func updateTransactionsListData() {
        totalBalance = "$12 5131.53"
        transactionList = []
        canceledImage = UIImage(systemName: "exclamationmark.circle")?
            .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 09",
                                               from: "0xty9 ... Bx9M",
                                               fiatValue: "15.53$",
                                               transactionCoin: .ethereum,
                                               amount: -0.0236))
        transactionList.append(TransactionInfo(type: .receive,
                                               date: "Sep 09",
                                               from: "0xty9 ... Bx9M",
                                               fiatValue: "15.53$",
                                               transactionCoin: .ethereum,
                                               amount: 1.12))
        transactionList.append(TransactionInfo(type: .receive,
                                               date: "Sep 08",
                                               from: "0xj3 ... 138f",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 1.55))
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 07",
                                               from: "0xj3 ... 138f",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 33))
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 07",
                                               from: "0xj3 ... 148f",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 33))
    }
}

// MARK: - TransactionType

enum TransactionType {

    case send
    case receive
}

// MARK: - WalletType

enum WalletType {

    case ethereum
    case bitcoin
    case aur

    // MARK: - Internal Properties

    var result: String {
        switch self {
        case .ethereum:
            return R.string.localizable.transactionETHFilter()
        case .aur:
            return R.string.localizable.transactionAURFilter()
        case .bitcoin:
            return "BTC"
        }
    }

    var chooseTitle: String {
        switch self {
        case .ethereum:
            return R.string.localizable.transactionETHFilter()
        case .aur:
            return R.string.localizable.transactionAURFilter()
        case .bitcoin:
            return "BTC (Bitcoin)"
        }
    }

    var abbreviatedName: String {
        switch self {
        case .ethereum:
            return "ETH"
        case .aur:
            return "AUR"
        case .bitcoin:
            return "BTC"
        }
    }
}

// MARK: - TransactionInfo

struct TransactionInfo: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var type: TransactionType
    var date: String
    var from: String
    var fiatValue: String
    var transactionCoin: WalletType
    var amount: Double
    var isTapped = false
}

// MARK: - WalletInfo

struct WalletInfo: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var walletType: WalletType
    var address: String
    var coinAmount: String
    var fiatAmount: String

    var result: (image: Image, fiatAmount: String, currency: String) {
        switch walletType {
        case .ethereum:
            return (R.image.wallet.ethereumCard.image,
                    coinAmount,
                    currency: "ETH")
        case .aur:
            return (R.image.wallet.card.image,
                    coinAmount,
                    currency: "AUR")
        case .bitcoin:
			return (R.image.wallet.ethereumCard.image,
                    coinAmount,
                    currency: "BTC")
        }
    }
}
