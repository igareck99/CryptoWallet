import Combine
import SwiftUI

// swiftlint:disable all

// MARK: - TransactionViewModel

final class TransactionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var transactionList: [TransactionInfo] = []
    @State var selectorFilterIndex = 0
    @State var selectorTokenIndex = 0

    // MARK: - Private Properties

    @Published private(set) var state: TransactionFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<TransactionFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<TransactionFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userCredentialsStorage: UserCredentialsStorage
    private let coordinator: WalletCoordinatable

    // MARK: - Lifecycle

    init(
        coordinator: WalletCoordinatable,
		userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared
	) {
        self.coordinator = coordinator
		self.userCredentialsStorage = userCredentialsStorage
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
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
        transactionList = []
    }
}
