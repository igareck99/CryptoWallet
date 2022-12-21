import Combine
import SwiftUI

final class TransferViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: TransferSceneDelegate?
	@Published var currentSpeed = TransactionMode.medium
    @Published var transferSum = 0

    // MARK: - Private Properties

    @Published private(set) var state: TransferFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<TransferFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<TransferFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userSettings: UserFlowsStorage & UserCredentialsStorage
	private let walletNetworks: WalletNetworkFacadeProtocol
	private let keysService: KeysServiceProtocol
	private let keychainService: KeychainServiceProtocol
	private let coreDataService: CoreDataServiceProtocol

	let sources: TransferViewSourcable.Type
	var fees = [TransactionSpeed]()
	var walletTypes = [WalletType]()
	var transferAmount: String = ""
	var transferAmountProxy: String {
		get { transferAmount }

		set {
			if validate(str: newValue) {
				self.transferAmount = newValue
			}
			objectWillChange.send()
		}
	}

	func validate(str: String) -> Bool {
		guard
			let regExp = try? Regex("^\\d{0,9}(?:\\.\\d{0,\(currentWallet.decimals)})?$")
		else {
			return false
		}
		let result = str.wholeMatch(of: regExp)
		return result?.isEmpty == false
	}

	var currentWallet: WalletInfo
	var currentWalletType: WalletType {
		didSet {
			updateWallet()
		}
	}

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
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onApprove:
					self?.transactionTemplate()
                case .onChooseReceiver:
                    self?.delegate?.handleNextScene(.chooseReceiver)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() { }

	private func transactionTemplate() {

		guard
			let value = try? Double(value: transferAmount),
			value > .zero
		else {
			return
		}

		let publicKey: String?
		let privateKey: String?

		if currentWalletType == .bitcoin {
			publicKey = keychainService[.bitcoinPublicKey]
			privateKey = keychainService[.bitcoinPrivateKey]
		} else {
			publicKey = keychainService[.ethereumPublicKey]
			privateKey = keychainService[.ethereumPrivateKey]
		}

		guard
			let walletPublicKey = publicKey,
			let walletPrivateKey = privateKey,
			let feeValue = fees.first(where: { [weak self] speed in
				speed.mode == self?.currentSpeed
			})?.feeValue
		else {
			return
		}
		debugPrint("walletPublicKey: \(walletPublicKey)")
		debugPrint("walletPrivateKey: \(walletPrivateKey)")

		let cryptoType = currentWalletType.rawValue
		debugPrint("walletCryptoType: \(cryptoType)")

		// TODO: Поменять на реальные адреса,
		// после того как доделаем экран адресов
		let address_to = "0xab33d517b6a63a0b1c099b8438d6641cf1a984cc"

		let params = TransactionTemplateRequestParams(
			publicKey: walletPublicKey,
			addressTo: address_to,
			amount: transferAmount,
			fee: feeValue,
			cryptoType: cryptoType
		)

		walletNetworks.makeTransactionTemplate(params: params) { [weak self] response in
			debugPrint("\(response)")
			guard
				let self = self,
				case .success(let template) = response,
				let templateHash = template.hashes.first,
				let derSignature = self.keysService.signBy(
					utxoHash: templateHash.hash,
					privateKey: walletPrivateKey
				)
			else {
				return
			}

			debugPrint("SIGNED: \(derSignature)")

			let transaction = FacilityApproveModel(
				reciverName: nil,
				reciverAddress: address_to,
				transferAmount: self.transferAmount,
				transferCurrency: self.currentWallet.result.currency,
				comissionAmount: feeValue,
				comissionCurrency: self.currentWallet.result.currency,
				derSignature: derSignature,
				index: templateHash.index,
				uuid: template.uuid,
				cryptoType: cryptoType
			)

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
		walletNetworks.getFee(feeParams: feeParams) { [weak self] result in
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
