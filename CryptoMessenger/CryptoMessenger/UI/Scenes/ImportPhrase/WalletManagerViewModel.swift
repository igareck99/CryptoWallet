import Combine
import SwiftUI

// MARK: - WalletManagerViewModel

final class WalletManagerViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: WalletManagerSceneDelegate?
    @Published var secretPhraseState = ""

    // MARK: - Private Properties

    @Published private(set) var state: WalletManagerFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<WalletManagerFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<WalletManagerFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
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

    func send(_ event: WalletManagerFlow.Event) {
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

    private func updateData() {
        secretPhraseState = userCredentialsStorage.secretPhraseState ?? ""
    }
}
