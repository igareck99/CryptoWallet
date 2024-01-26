import Combine
import SwiftUI

// swiftlint:disable all

protocol FacilityApproveViewCoordinatable {
    func onTransactionEnd(model: TransactionResult)
}

// MARK: - FacilityApproveViewModel

final class FacilityApproveViewModel: ObservableObject {

	// MARK: - Internal Properties

	var transaction: FacilityApproveModel
    var isSnackbarPresented = false
    var messageText: String = ""
	@Published var cellType: [ApproveFacilityCellTitle] = []

	// MARK: - Private Properties

	@Published private(set) var state: FacilityApproveFlow.ViewState = .idle
	private let eventSubject = PassthroughSubject<FacilityApproveFlow.Event, Never>()
	private let stateValueSubject = CurrentValueSubject<FacilityApproveFlow.ViewState, Never>(.idle)
	private var subscriptions = Set<AnyCancellable>()

	@Injectable private var apiClient: APIClientManager
	private let userCredentialsStorage: UserCredentialsStorage
	private let walletNetworks: WalletNetworkFacadeProtocol
    private let coordinator: FacilityApproveViewCoordinatable
    let resources: FacilityApproveSourcesable.Type

	// MARK: - Lifecycle

	init(
        transaction: FacilityApproveModel,
        coordinator: FacilityApproveViewCoordinatable,
		walletNetworks: WalletNetworkFacadeProtocol = WalletNetworkFacade(),
		userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared,
		resources: FacilityApproveSourcesable.Type = FacilityApproveSources.self
	) {
		self.transaction = transaction
        self.coordinator = coordinator
		self.walletNetworks = walletNetworks
		self.userCredentialsStorage = userCredentialsStorage
		self.resources = resources
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
            image: R.image.facilityApprove.facilityApproveRounds.adress.image,
			title: R.string.localizable.facilityApproveRecipientAddress(),
			text: transaction.reciverName ?? transaction.reciverAddress ?? ""
		))

		let transferAmount = transaction.transferAmount + " " + transaction.transferCurrency
		cellType.append(.init(
            image: R.image.facilityApprove.facilityApproveRounds.creditCard.image,
			title: R.string.localizable.facilityApproveTransactionSum(),
			text: transferAmount
		))

		let comission = transaction.comissionAmount + " " + transaction.comissionCurrency
		cellType.append(.init(
            image: R.image.facilityApprove.facilityApproveRounds.percent.image,
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

		let signatures: [TransactionSendRequestSignature] = transaction
			.signedTransactions.map { signedTransaction in
				TransactionSendRequestSignature(
					index: signedTransaction.index,
					derSignature: signedTransaction.derSignature
				)
			}

		let params = TransactionSendRequestParams(
			signatures: signatures,
			uuid: transaction.uuid,
			cryptoType: transaction.cryptoType
		)
		walletNetworks.makeTransactionSend(params: params) { [weak self] result in
			debugPrint("Transaction Send: RESULT: \(result)")
			guard let self = self,
				  case let .success(response) = result else {
                // MARK: - Пока добавил для того чтобы был переход в кошелек
                // нужно будет обновить, когда будем прорабатывать ошибки
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.transactionresult(
                        title: R.string.localizable.facilityApproveTransactionFailed(),
                        imageName: R.image.transaction.successOperation.name,
                        isSuccess: false,
                        failDescription: "Транзакция не удалась"
                    )
                }
                self?.showSnackBar(text: "Транзакция не удалась")
                return
            }
			debugPrint("Transaction Send: RESPONSE: \(response)")
			DispatchQueue.main.async { [weak self] in
				guard let self = self else {
                    self?.showSnackBar(text: "Транзакция не удалась")
                    return
                }
                self.transactionresult(
                    title: R.string.localizable.facilityApproveTransactionDone(),
                    imageName: R.image.transaction.successOperation.name,
                    rawTransaction: response
                )
			}
		}
	}
    
    private func transactionresult(
        title: String,
        imageName: String,
        isSuccess: Bool = true,
        failDescription: String? = nil,
        rawTransaction: TransactionSendResponse? = nil
    ) {
        let receiverName: String = self.transaction.reciverName ?? R.string.localizable.facilityApproveReceiver()
        let model = TransactionResult(
            title: title,
            resultImageName: imageName,
            amount: self.transaction.transferAmount + " " + self.transaction.transferCurrency,
            receiverName: receiverName,
            receiversWallet: self.transaction.reciverAddress ?? "",
            result: isSuccess ? .success : .fail(failDescription ?? "failed"),
            transferAmount: transaction.transferAmount,
            transferCurrency: transaction.transferCurrency,
            comissionAmount: transaction.comissionAmount,
            comissionCurrency: transaction.comissionCurrency,
            cryptoType: transaction.cryptoType,
            txHash: rawTransaction?.hash
        )
        self.coordinator.onTransactionEnd(model: model)
    }
}
