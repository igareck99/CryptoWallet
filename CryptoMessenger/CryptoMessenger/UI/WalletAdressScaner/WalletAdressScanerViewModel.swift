import SwiftUI
import Combine

// MARK: - WalletAdressScanerViewModel

final class WalletAddressScanerViewModel: ObservableObject {

    // MARK: - Internal Properties

    let resources: WalletAdressScanerResourcable.Type

    // MARK: - Private Properties
    
    @Published private(set) var state: WalletAddressScanerFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<WalletAddressScanerFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<WalletAddressScanerFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private var userSettings: UserFlowsStorage & UserCredentialsStorage
    

    // MARK: - Lifecycle

    init(
        userSettings: UserFlowsStorage & UserCredentialsStorage,
        resources: WalletAdressScanerResourcable.Type = WalletAdressScanerResources.self
    ) {
        self.resources = resources
        self.userSettings = userSettings
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: WalletAddressScanerFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    ()
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
