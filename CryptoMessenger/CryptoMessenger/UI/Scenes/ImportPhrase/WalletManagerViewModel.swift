import Combine
import SwiftUI

// MARK: - WalletManagerViewModel

final class WalletManagerViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: WalletManagerSceneDelegate?
    let resources: ImportPhraseResourcable.Type = ImportPhraseResources.self

    // MARK: - Private Properties

    @Published private(set) var state: WalletManagerFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<WalletManagerFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<WalletManagerFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private var keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
		keychainService: KeychainServiceProtocol,
        resources: ImportPhraseResourcable.Type = ImportPhraseResources.self
	) {
        self.keychainService = keychainService
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: WalletManagerFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onKeyList:
                    self?.delegate?.handleNextScene(.keyList)
                case .onPhrase:
                    self?.delegate?.handleNextScene(.phraseManager)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    func secretPhraseValidate(toCompare: String) -> Bool {
        return toCompare == keychainService.secretPhrase
    }
}
