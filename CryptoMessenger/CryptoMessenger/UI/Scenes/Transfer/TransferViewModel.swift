import Combine
import SwiftUI

final class TransferViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: TransferSceneDelegate?
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

	private var addressTo: String = ""

	let sources: TransferViewSourcable.Type
	var fees = [TransactionSpeed]()
	var walletTypes = [WalletType]()

	var isSnackbarPresented = false

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

    // MARK: - Lifecycle

    init(
		wallet: WalletInfo,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		keysService: KeysServiceProtocol = KeysService(),
		walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
		userSettings: UserFlowsStorage & UserCredentialsStorage = UserDefaultsService.shared,
		coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
		sources: TransferViewSourcable.Type = TransferViewSources.self
	) {
		self.currentWallet = wallet
		self.currentWalletType = wallet.walletType
		self.keychainService = keychainService
		self.keysService = keysService
		self.walletNetworks = walletNetworks
		self.userSettings = userSettings
		self.coreDataService = coreDataService
		self.sources = sources
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

		guard let selectedWallet = coreDataService
			.getWalletNetworks()
			.first(where: { [weak self] dbWallet in
				guard let self = self else { return false }
				return dbWallet.cryptoType == self.currentWalletType.rawValue
			}),
			  let walletType = WalletType(rawValue: selectedWallet.cryptoType)
		else {
			return
		}

		currentWallet = WalletInfo(
			decimals: Int(selectedWallet.decimals),
			walletType: walletType,
			address: selectedWallet.address,
			coinAmount: selectedWallet.balance ?? "",
			fiatAmount: selectedWallet.balance ?? ""
		)
		getFees()
		objectWillChange.send()
	}

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onApprove:
					self?.transactionTemplate()
                case let .onChooseReceiver(address):
                    self?.delegate?.handleNextScene(.chooseReceiver(address))
				case let .onAddressChange(address):
					self?.addressTo = address
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

	private func displayErrorSnackBar() {
		DispatchQueue.main.async { [weak self] in
			self?.isSnackbarPresented = true
			self?.objectWillChange.send()
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
			self?.isSnackbarPresented = false
			self?.objectWillChange.send()
		}
	}

	private func transactionTemplate() {

		guard isTransferAmountValid() else { return }

		// TODO: Поменять на реальные адреса,
		// после того как доделаем экран адресов

		let walletPublicKey: String
		let walletPrivateKey: String

		if currentWalletType == .bitcoin,
		   let publicKey: String = keychainService[.bitcoinPublicKey],
		   let privateKey: String = keychainService[.bitcoinPrivateKey] {
			walletPublicKey = publicKey
			walletPrivateKey = privateKey
//			address_to = "moaCiMa3xBGEVEeHMZZKsDvfSC5GyRyZCZ"
		} else if currentWalletType == .ethereum,
				  let publicKey: String = keychainService[.ethereumPublicKey],
				  let privateKey: String = keychainService[.ethereumPrivateKey] {
			walletPublicKey = publicKey
			walletPrivateKey = privateKey
//			address_to = "0xe8f0349166f87fba444596a6bbbe5de9e9c6ef27"
//			"0xccb5c140b7870061dc5327134fbea8f3f2e154d9"
		} else {
			addressTo = ""
			walletPublicKey = ""
			walletPrivateKey = ""
			return
		}

		guard let feeValue = fees
			.first(where: { [weak self] speed in
				speed.mode == self?.currentSpeed
			})?.feeValue
		else {
			return
		}
		debugPrint("walletPublicKey: \(walletPublicKey)")
		debugPrint("walletPrivateKey: \(walletPrivateKey)")

		let cryptoType = currentWalletType.rawValue
		debugPrint("walletCryptoType: \(cryptoType)")

		let params = TransactionTemplateRequestParams(
			publicKey: walletPublicKey,
			addressTo: addressTo,
			amount: transferAmount,
			fee: feeValue,
			cryptoType: cryptoType
		)

		walletNetworks.makeTransactionTemplate(params: params) { [weak self] response in
			debugPrint("\(response)")
			guard
				let self = self,
				case .success(let template) = response
			else {
				self?.displayErrorSnackBar()
				return
			}

			let signedTransactions: [SignedTransaction] = template.hashes.compactMap { item in

				guard let derSignature = self.keysService.signBy(
					utxoHash: item.hash,
					privateKey: walletPrivateKey
				) else {
					return nil
				}

				debugPrint("SIGNED: \(derSignature)")

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

			debugPrint("SIGNED transaction: \(transaction)")

			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.delegate?.handleNextScene(.facilityApprove(transaction))
			}
		}
	}

	private func getFees() {
		let cryptoType: String = currentWallet.walletType.rawValue
		let currencyName: String = currentWallet.walletType.abbreviatedName
		let feeParams = FeeRequestParams(cryptoType: cryptoType)
		walletNetworks.getFee(params: feeParams) { [weak self] result in
			debugPrint("\(result)")

			guard let self = self else { return }
			guard case let .success(response) = result else { return }
			let slow = TransactionSpeed(
				title: self.sources.transferSlow,
				feeText: "\(response.fee.slow) \(currencyName)",
				feeValue: "\(response.fee.slow)",
				mode: .slow
			)
			let medium = TransactionSpeed(
				title: self.sources.transferMiddle,
				feeText: "\(response.fee.average) \(currencyName)",
				feeValue: "\(response.fee.average)",
				mode: .medium
			)

			let fast = TransactionSpeed(
				title: self.sources.transferFast,
				feeText: "\(response.fee.fast) \(currencyName)",
				feeValue: "\(response.fee.fast)",
				mode: .fast
			)

			self.fees = [slow, medium, fast]
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}

	private func getWallets() {
		walletTypes = coreDataService.getWalletsTypes()
	}
}
