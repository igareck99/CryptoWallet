import Combine
import SwiftUI

// MARK: - TransactionViewModel

final class TransactionViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: TransactionSceneDelegate?
    @Published var transactionList: [TransactionInfo] = []
    @State var selectorFilterIndex = 0
    @State var selectorTokenIndex = 0

    // MARK: - Private Properties

    @Published private(set) var state: TransactionFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<TransactionFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<TransactionFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Lifecycle

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: TransactionFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in

            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
        transactionList = []
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 09",
                                               from: "0xks1...ka9a",
                                               fiatValue: "15.53$",
                                               transactionCoin: .ethereum,
                                               amount: -0.0236))
        transactionList.append(TransactionInfo(type: .receive,
                                               date: "Sep 09",
                                               from: "0xks1...ka9a",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 1.12))
        transactionList.append(TransactionInfo(type: .receive,
                                               date: "Sep 08",
                                               from: "0xss1...fe9e",
                                               fiatValue: "15.53$",
                                               transactionCoin: .ethereum,
                                               amount: 1.55))
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 07",
                                               from: "0xss1...fe9e",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 33))
    }
}
