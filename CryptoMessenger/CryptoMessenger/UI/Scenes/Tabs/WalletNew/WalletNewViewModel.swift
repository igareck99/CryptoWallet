import Combine
import SwiftUI
import HDWalletKit

// MARK: - WalletNewViewModel

final class WalletNewViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: WalletNewSceneDelegate?
    @Published var totalBalance = ""
    @Published var transactionList: [TransactionInfo] = []
    @Published var cardsList: [WalletInfo] = [
        .init(
            walletType: .ethereum,
            address: "0xty9 ... Bx9M",
            coinAmount: "1.012",
            fiatAmount: "33"
        ),
        .init(  
            walletType: .aur,
            address: "0xj3 ... 138f",
            coinAmount: "2.3042",
            fiatAmount: "18.1342"
        ),
        .init(
            walletType: .aur,
            address: "0xj3 ... 148f",
            coinAmount: "2.3042",
            fiatAmount: "18.1342"
        )
    ]
    @Published var canceledImage = UIImage()

    // MARK: - Private Properties

    @Published private(set) var state: WalletNewFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<WalletNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<WalletNewFlow.ViewState, Never>(.idle)
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
		let params: [String: Any] = [
			"ethereum": [["publicKey": ethereumPublicKey.dropFirst(2)]],
			"bitcoin": [["publicKey": bitcoinPublicKey.dropFirst(2)]]
		]

		walletNetworks.getAddress(parameters: params) { [weak self] addressResponse in
			guard let self = self else { return }

			debugPrint("getAddress address result: \(addressResponse)")

			guard case let .success(addresses) = addressResponse else { return }
			debugPrint("getAddress address: \(addresses)")

			let savedWallets: [WalletNetwork] = self.coreDataService.getWalletNetworks()
			debugPrint("getAddress savedWallets: \(savedWallets)")

			if let ethereumAddress: String = addresses.ethereum?.first?.address,
			   let wallet: WalletNetwork = savedWallets.first(where: { $0.cryptoType == CryptoType.ethereum.rawValue }) {
				   wallet.address = ethereumAddress
				   self.coreDataService.updateWalletNetwork(model: wallet)
			   }

			if let bitcoinAddress = addresses.bitcoin?.first?.address,
			   let wallet: WalletNetwork = savedWallets.first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue }) {
				   wallet.address = bitcoinAddress
				   self.coreDataService.updateWalletNetwork(model: wallet)
			   }

			let updatedWallets = self.coreDataService.getWalletNetworks()
			debugPrint("getAddress updatedWallets: \(updatedWallets)")

			self.getBalance()
		}
	}

	func getBalance() {

		let savedWallets: [WalletNetwork] = self.coreDataService.getWalletNetworks()
		guard let bitcoinAddress = savedWallets.first(where: { $0.cryptoType == "bitcoin" })?.address,
			  let ethereumAddress = savedWallets.first(where: { $0.cryptoType == "ethereum" })?.address else { return }

		let params: [String: Any] = [
			"ethereum": [["accountAddress": ethereumAddress]],
			"bitcoin": [["accountAddress": bitcoinAddress]]
		]
		walletNetworks.getBalances(parameters: params) {
			debugPrint("getBalance balance result: \($0)")
			guard case let .success(balance) = $0 else { return }
			debugPrint("getBalance balance: \(balance)")

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

			let updatedWallets = self.coreDataService.getWalletNetworks()
			debugPrint("getBalance updatedWallets: \(updatedWallets)")

			let cards: [WalletInfo] = updatedWallets.map {
				let walletType: WalletType = $0.cryptoType == "ethereum" ? WalletType.ethereum : WalletType.bitcoin
				return WalletInfo(walletType: walletType, address: $0.address, coinAmount: $0.balance ?? "0", fiatAmount: "0")
			}

			DispatchQueue.main.async {
				self.cardsList = cards
			}
		}
	}

	func updateWallets() {

		coreDataService.deleteAllWalletNetworks()
		walletNetworks.getNetworks { [weak self] networks in

			guard let self = self else { return }

			debugPrint("updateWallets getNetworks networks: \(networks)")
			guard case let .success(wallets) = networks else { return }
			debugPrint("updateWallets getNetworks networks: \(wallets)")
			wallets.forEach { [weak self] in
				guard let self = self else { return }
				self.coreDataService.createWalletNetwork(wallet: $0)
			}
			let savedWallets = self.coreDataService.getWalletNetworks()
			debugPrint("updateWallets savedWallets: \(savedWallets)")

//				guard let seed = self.keychainService.secretPhrase else { return }
			let seed = "trade icon company use feature fee order double inhale gift news long"

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

    func send(_ event: WalletNewFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
					self?.updateWallets()
                    self?.updateData()
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
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
	
    private func updateData() {
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
