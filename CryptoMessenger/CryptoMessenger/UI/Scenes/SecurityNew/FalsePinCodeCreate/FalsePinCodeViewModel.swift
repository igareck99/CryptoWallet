import SwiftUI
import Combine

final class FalsePinCodeViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: FalsePinCodeSceneDelegate?

    // MARK: - Private Properties

    @Published private(set) var state: FalsePinCodeCreateFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<FalsePinCodeCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<FalsePinCodeCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlows: UserFlowsStorageService

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

    func send(_ event: FalsePinCodeCreateFlow.Event) {
        eventSubject.send(event)
    }

    func createPassword(item: String) {
        if userCredentialsStorageService.userFalsePinCode == item {
            return
        }
        userCredentialsStorageService.userFalsePinCode = item
        userFlows.isFalsePinCodeOn = true
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
    }
}
