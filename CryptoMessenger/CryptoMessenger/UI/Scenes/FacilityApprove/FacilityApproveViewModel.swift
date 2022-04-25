import Combine
import SwiftUI

// MARK: - FacilityApproveViewModel

final class FacilityApproveViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: FacilityApproveSceneDelegate?
    @Published var transaction = TransactionInfoApprove(
        userImage: R.image.blackList.user1.image,
        nameSurname: "Марина Антоненко",
        type: .receive,
        date: "1 ноября 2020",
        fiatValue: "28.53 USD",
        addressFrom: "0xSf13S891 ... 3dfasfAgfj1 ",
        commission: "0 ETH",
        transactionCoin: .aur,
        amount: 2500
    )
    @Published var nameTitle = R.string.localizable.facilityApproveNameSurname()
    @Published var titles = [
        R.string.localizable.facilityApproveTransactionSum(),
        R.string.localizable.facilityApproveInUSD(),
        R.string.localizable.facilityApproveCommission(),
        R.string.localizable.facilityApproveAddress(),
        R.string.localizable.facilityApproveDocumentDate()
    ]
    @Published var cellType: [ApproveFacilityCellTitle] = []

    // MARK: - Private Properties

    @Published private(set) var state: FacilityApproveFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<FacilityApproveFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<FacilityApproveFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
	private let userCredentialsStorage: UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		userCredentialsStorage: UserCredentialsStorage
	) {
		self.userCredentialsStorage = userCredentialsStorage
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
        if transaction.type == .receive {
            cellType.append(.init(image: R.image.facilityApprove.wallet.image,
                                  title: R.string.localizable.facilityApproveTransactionSum(),
                                  text: String(transaction.amount) + " " + transaction.transactionCoin.abbreviatedName))
            cellType.append(.init(image: R.image.facilityApprove.usd.image,
                                  title: R.string.localizable.facilityApproveInUSD(),
                                  text: transaction.fiatValue))
        } else {
            cellType.append(.init(image: R.image.facilityApprove.wallet.image,
                                  title: R.string.localizable.facilityApproveTransactionSum(),
                                  text: "- " + String(transaction.amount)
                                  + " " + transaction.transactionCoin.abbreviatedName))
            cellType.append(.init(image: R.image.facilityApprove.usd.image,
                                  title: R.string.localizable.facilityApproveInUSD(),
                                  text: "- " + transaction.fiatValue))
        }
        cellType.append(.init(image: R.image.facilityApprove.percent.image,
                              title: R.string.localizable.facilityApproveCommission(),
                              text: transaction.commission))
        cellType.append(.init(image: R.image.facilityApprove.address.image,
                              title: R.string.localizable.facilityApproveAddress(),
                              text: transaction.addressFrom ))
        cellType.append(.init(image: R.image.facilityApprove.document.image,
                              title: R.string.localizable.facilityApproveDocumentDate(),
                              text: transaction.date))
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
                    debugPrint("SomeGox")
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

// MARK: - TransactionInfoApprove

struct TransactionInfoApprove: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var userImage: Image
    var nameSurname: String
    var type: TransactionType
    var date: String
    var fiatValue: String
    var addressFrom: String
    var commission: String
    var transactionCoin: WalletType
    var amount: Double
}

// MARK: - ApproveFacilityCellTitle

struct ApproveFacilityCellTitle: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var image: Image
    var title: String
    var text: String
}
