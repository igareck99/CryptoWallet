import SwiftUI
import Combine

final class TransferViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: TransferSceneDelegate?
    @Published var currentSpeed = TransferSpeed.middle
    @Published var transferSum = 0

    // MARK: - Private Properties

    @Published private(set) var state: TransferFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<TransferFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<TransferFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userSettings: UserFlowsStorage & UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		userSettings: UserFlowsStorage & UserCredentialsStorage
	) {
		self.userSettings = userSettings
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: TransferFlow.Event) {
        eventSubject.send(event)
    }
    
    func updateTransactionSpeed(item: TransferSpeed) {
        currentSpeed = item
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
                    self?.delegate?.handleNextScene(.facilityApprove)
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

    private func updateData() {
    }
}
