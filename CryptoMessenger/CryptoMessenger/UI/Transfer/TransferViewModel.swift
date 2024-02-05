import Combine
import SwiftUI
import MatrixSDK

// swiftlint:disable all

protocol TransferViewCoordinatable {

    // Выбрали получателя
    func chooseReceiver(address: Binding<UserReceiverData>)

    // Создали template транзакции
    func didCreateTemplate(transaction: FacilityApproveModel)
    
    func previousScreen()
    
    func showAdressScanner(_ value: Binding<String>)
}

final class TransferViewModel: ObservableObject {

    // MARK: - Internal Properties

	@Published var currentSpeed = TransactionMode.medium
    @Published var transferSum = 0

    // MARK: - Private Properties

    @Published private(set) var state: TransferFlow.ViewState = .idle
    @Published private(set) var contacts: [Contact] = []
    @Published var userIds: [String] = []
    private let eventSubject = PassthroughSubject<TransferFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<TransferFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userSettings: UserFlowsStorage & UserCredentialsStorage
	private let walletNetworks: WalletNetworkFacadeProtocol
	private let keysService: KeysServiceProtocol
	private let keychainService: KeychainServiceProtocol
	private let coreDataService: CoreDataServiceProtocol
    private let coordinator: TransferViewCoordinatable
	private var addressTo: String = ""

    private let feeItemsFactory: FeeItemsFactoryProtocol.Type
	let resources: TransferViewSourcable.Type
    @Published var fees = [TransactionSpeed]()
	var walletTypes = [WalletType]()

	var isSnackbarPresented = false
    var messageText: String = ""

	var isTransferButtonEnabled: Bool {
		transferAmount.isEmpty == false &&
		isTransferAmountValid() &&
		validate(str: transferAmount)
	}
	private var transferAmount: String = ""
	var transferAmountProxy: String {
		get { transferAmount }

		set {
			if validate(str: newValue) {
				self.transferAmount = newValue
			}
			objectWillChange.send()
		}
	}

	private func validate(str: String) -> Bool {

        if let separator = Locale.current.decimalSeparator,
            let regExp = try?
            Regex("^\\d{0,9}(?:\\\(separator)\\d{0,\(currentWallet.decimals)})?$") {
            let result = str.wholeMatch(of: regExp)
            return result?.isEmpty == false
        }
		return false
	}

    private let formatter: NumberFormatter = {
        let separator = Locale.current.decimalSeparator
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = separator
        return formatter
    }()

	private func isTransferAmountValid() -> Bool {
        let value: Double = formatter.number(from: transferAmount)?.doubleValue ?? .zero
		return value > .zero
	}

	var currentWallet: WalletInfo
	var currentWalletType: WalletType {
		didSet {
			updateWallet()
		}
	}
    @Injectable private var apiClient: APIClientManager
    @Injectable private var contactsStore: ContactsManager
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    
    @Published var receiverData: UserReceiverData = UserReceiverData(
        name: "",
        url: URL(string: ""),
        adress: "",
        walletType: .ethereum
    )

    // MARK: - Lifecycle

    init(
		wallet: WalletInfo,
        coordinator: TransferViewCoordinatable,
        receiverData: UserReceiverData? = nil,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		keysService: KeysServiceProtocol = KeysService(),
		walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
		userSettings: UserFlowsStorage & UserCredentialsStorage = UserDefaultsService.shared,
		coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
		resources: TransferViewSourcable.Type = TransferViewSources.self,
        feeItemsFactory: FeeItemsFactoryProtocol.Type = FeeItemsFactory.self
	) {
		self.currentWallet = wallet
        self.coordinator = coordinator
        if let rData = receiverData {
            self.receiverData = rData
            self.addressTo = rData.adress
            self.currentWalletType = rData.walletType
        }
		self.currentWalletType = wallet.walletType
		self.keychainService = keychainService
		self.keysService = keysService
		self.walletNetworks = walletNetworks
		self.userSettings = userSettings
		self.coreDataService = coreDataService
		self.resources = resources
        self.feeItemsFactory = feeItemsFactory
        bindInput()
        bindOutput()
		getFees()
		getWallets()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: TransferFlow.Event) {
        eventSubject.send(event)
    }

    func updateTransactionSpeed(item: TransactionMode) {
        currentSpeed = item
    }

    func updateWallet() {
        Task {
            let networkWallets: [String: WalletNetwork] = await coreDataService.getWalletNetworks()
                .reduce(into: [String: WalletNetwork]()) { partialResult, wallet in
                    if let key: String = wallet.cryptoType {
                        partialResult[key] = wallet
                    }
                }
            let tokenNetworks: [String: NetworkToken] = await coreDataService.getNetworksTokens()
                .reduce(into: [String: NetworkToken]()) { partialResult, token in
                    if let network = token.network,
                       let symbol = token.symbol {
                        let key: String = network + symbol
                        partialResult[key] = token
                    }
                }
            
            if let selectedWallet = networkWallets[currentWalletType.rawValue],
               let cryptoType = selectedWallet.cryptoType,
               let walletType = WalletType(rawValue: cryptoType) {
                
                currentWallet = WalletInfo(
                    decimals: Int(selectedWallet.decimals),
                    walletType: walletType,
                    address: selectedWallet.address ?? "",
                    coinAmount: selectedWallet.balance ?? "",
                    fiatAmount: selectedWallet.balance ?? ""
                )
            } else if let tokenNetwork = tokenNetworks[currentWalletType.rawValue],
                      let network = tokenNetwork.network,
                      let symbol = tokenNetwork.symbol,
                      let walletType = WalletType(rawValue: network + symbol),
                      let networkWallet = networkWallets[network],
                      let address = networkWallet.address {
                
                currentWallet = WalletInfo(
                    decimals: Int(tokenNetwork.decimals),
                    walletType: walletType,
                    address: address,
                    tokenAddress: tokenNetwork.address,
                    coinAmount: tokenNetwork.balance ?? "",
                    fiatAmount: tokenNetwork.balance ?? ""
                )
            }
            
            getFees()
            await MainActor.run {
                objectWillChange.send()
            }
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .onAppear:
                    self.objectWillChange.send()
                case .onApprove:
					self.transactionTemplate()
                case .onChooseReceiver:
                    self.receiverData.walletType = self.currentWallet.walletType
                        self.coordinator.chooseReceiver(address: Binding(get: {
                            self.receiverData
                        }, set: { value, transaction in
                            debugPrint("TransferViewModel bindInput transaction: \(transaction)")
                            self.receiverData = value
                        }))
				case let .onAddressChange(address):
					self.addressTo = address
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    func showSnackBar(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageText = text
            self?.isSnackbarPresented = true
            self?.objectWillChange.send()
        }

        delay(3) { [weak self] in
            self?.messageText = ""
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }

	private func transactionTemplate() {

		guard isTransferAmountValid() else {
            self.showSnackBar(text: "Ошибка перевода")
            return
        }

		let walletPublicKey: String
		let walletPrivateKey: String
        let cryptoType: String

		if currentWalletType == .bitcoin,
		   let publicKey: String = keychainService[.bitcoinPublicKey],
		   let privateKey: String = keychainService[.bitcoinPrivateKey] {
			walletPublicKey = publicKey
			walletPrivateKey = privateKey
            cryptoType = WalletType.bitcoin.rawValue
//			address_to = "moaCiMa3xBGEVEeHMZZKsDvfSC5GyRyZCZ"
        } else if (currentWalletType == .ethereum ||
                   currentWalletType == .ethereumUSDC ||
                   currentWalletType == .ethereumUSDT),
                  let publicKey: String = keychainService[.ethereumPublicKey],
                  let privateKey: String = keychainService[.ethereumPrivateKey] {
            walletPublicKey = publicKey
            walletPrivateKey = privateKey
            cryptoType = WalletType.ethereum.rawValue
//			address_to = "0xe8f0349166f87fba444596a6bbbe5de9e9c6ef27"
//			"0xccb5c140b7870061dc5327134fbea8f3f2e154d9"
        } else if (currentWalletType == .binance ||
                   currentWalletType == .binanceUSDT ||
                   currentWalletType == .binanceBUSD),
                  let publicKey: String = keychainService[.binancePublicKey],
                  let privateKey: String = keychainService[.binancePrivateKey] {
            walletPublicKey = publicKey
            walletPrivateKey = privateKey
            cryptoType = WalletType.binance.rawValue
        } else if (currentWalletType == .aura),
                  let publicKey: String = keychainService[.auraPublicKey],
                  let privateKey: String = keychainService[.auraPrivateKey] {
            walletPublicKey = publicKey
            walletPrivateKey = privateKey
            cryptoType = WalletType.aura.rawValue
        } else {
            addressTo = ""
            cryptoType = ""
			walletPublicKey = ""
			walletPrivateKey = ""
			return
		}

		guard let feeValue = fees
			.first(where: { [weak self] speed in
				speed.mode == self?.currentSpeed
			})?.feeValue
		else {
            self.showSnackBar(text: "Ошибка начисления комиссии")
            return
		}

        let amount = transferAmount.replacingOccurrences(of: ",", with: ".")

		let params = TransactionTemplateRequestParams(
			publicKey: walletPublicKey,
			addressTo: addressTo,
            tokenAddress: currentWallet.tokenAddress,
			amount: amount,
			fee: feeValue,
			cryptoType: cryptoType
		)

		walletNetworks.makeTransactionTemplate(params: params) { [weak self] response in
			guard
				let self = self,
				case .success(let template) = response
			else {
                self?.showSnackBar(text: "Не удалось создать template")
				return
			}

			let signedTransactions: [SignedTransaction] = template.hashes.compactMap { item in

				guard let derSignature = self.keysService.signBy(
					utxoHash: item.hash,
					privateKey: walletPrivateKey
				) else {
					return nil
				}

				return SignedTransaction(derSignature: derSignature, index: item.index)
			}

			let transaction = FacilityApproveModel(
				reciverName: nil,
				reciverAddress: self.addressTo,
				transferAmount: self.transferAmount,
				transferCurrency: self.currentWallet.result.currency,
				comissionAmount: feeValue,
				comissionCurrency: self.currentWallet.result.currency,
				signedTransactions: signedTransactions,
				uuid: template.uuid,
				cryptoType: cryptoType
			)

			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
                self.coordinator.didCreateTemplate(transaction: transaction)
			}
		}
	}

	private func getFees() {
        let cryptoType: String = currentWallet.walletType.feeWalletType.lowercased()
		let feeCurrency: String = currentWallet.walletType.feeCurrency
		let feeParams = FeeRequestParams(cryptoType: cryptoType)
		walletNetworks.getFee(params: feeParams) { [weak self] result in
			debugPrint("getFees: \(result)")

			guard let self = self,
                  case let .success(response) = result
            else {
                self?.showSnackBar(text: "Ошибка получения комиссии")
                return
            }
			
            Task {
                await MainActor.run {
                    self.fees = self.feeItemsFactory.make(
                        feesModel: response,
                        sources: self.resources,
                        currency: feeCurrency
                    )
                }
            }
		}
	}

	private func getWallets() {
        Task {
            let tokenWalletTypes = await coreDataService.getNetworkTokensWalletsTypes()
            let networkWalletTypes = await coreDataService.getNetworkWalletsTypes()
            walletTypes = networkWalletTypes + tokenWalletTypes
        }
	}
}
