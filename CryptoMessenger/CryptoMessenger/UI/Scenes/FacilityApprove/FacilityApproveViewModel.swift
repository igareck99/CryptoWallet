import Combine
import SwiftUI

// MARK: - FacilityApproveViewModel

final class FacilityApproveViewModel: ObservableObject {

	// MARK: - Internal Properties

	weak var delegate: FacilityApproveSceneDelegate?
	var transaction: FacilityApproveModel
	@Published var cellType: [ApproveFacilityCellTitle] = []

	// MARK: - Private Properties

	@Published private(set) var state: FacilityApproveFlow.ViewState = .idle
	private let eventSubject = PassthroughSubject<FacilityApproveFlow.Event, Never>()
	private let stateValueSubject = CurrentValueSubject<FacilityApproveFlow.ViewState, Never>(.idle)
	private var subscriptions = Set<AnyCancellable>()

	@Injectable private var apiClient: APIClientManager
	private let userCredentialsStorage: UserCredentialsStorage
	private let sources: FacilityApproveSourcesable.Type
	private let walletNetworks: WalletNetworkFacadeProtocol

	// MARK: - Lifecycle

	init(
		transaction: FacilityApproveModel,
		walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
		userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared,
		sources: FacilityApproveSourcesable.Type = FacilityApproveSources.self
	) {
		self.transaction = transaction
		self.walletNetworks = walletNetworks
		self.userCredentialsStorage = userCredentialsStorage
		self.sources = sources
		bindInput()
		bindOutput()
	}

	deinit {
		subscriptions.forEach { $0.cancel() }
		subscriptions.removeAll()
	}

	// MARK: - Internal Methods

	func send(_ event: FacilityApproveFlow.Event) {
		eventSubject.send(event)
	}

	func addTitles() {

		cellType.append(.init(
			image: R.image.facilityApprove.address.image,
			title: R.string.localizable.facilityApproveAddress(),
			text: transaction.reciverName ?? transaction.reciverAddress ?? ""
		))

		let transferAmount = transaction.transferAmount + " " + transaction.transferCurrency
		cellType.append(.init(
			image: R.image.facilityApprove.wallet.image,
			title: R.string.localizable.facilityApproveTransactionSum(),
			text: transferAmount
		))

		let comission = transaction.comissionAmount + " " + transaction.comissionCurrency
		cellType.append(.init(
			image: R.image.facilityApprove.percent.image,
			title: R.string.localizable.facilityApproveCommission(),
			text: comission
		))
	}

	// MARK: - Private Methods

	private func bindInput() {
		eventSubject
			.sink { [weak self] event in
				switch event {
				case .onAppear:
					self?.updateData()
					self?.objectWillChange.send()
				case .onTransaction:
					self?.transactionSend()
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
		if cellType.isEmpty {
			addTitles()
		}
	}
}

// MARK: - Network

extension FacilityApproveViewModel {

	private func transactionSend() {

		let signature = TransactionSendRequestSignature(
			index: transaction.index,
			derSignature: transaction.derSignature
		)
		let params = TransactionSendRequestParams(
			signatures: [signature],
			uuid: transaction.uuid,
			cryptoType: transaction.cryptoType
		)
		walletNetworks.makeTransactionSend(params: params) { [weak self] result in
			debugPrint("\(result)")
			guard let self = self else { return }
			guard case let .success(response) = result else { return }
			debugPrint("Transaction Send: \(response)")
			DispatchQueue.main.async { [weak self] in
				self?.delegate?.handleNextScene(.popToRoot)
			}
		}
	}
}

//   0xc435a4ae92c9a509ea7b928cfdd2ee99bfcd3c5940d20f230e224cc9f1648586
