import SwiftUI
import HDWalletKit
import Combine

// MARK: - ImportKeyViewModel

final class ImportKeyViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ImportKeySceneDelegate?
    @Published var walletError = true

    // MARK: - Private Properties

    @Published private(set) var state: ImportKeyFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ImportKeyFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ImportKeyFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private var keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init() {
        self.keychainService = KeychainService.shared
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ImportKeyFlow.Event) {
        eventSubject.send(event)
    }

    func createWallet(item: String, type: WalletType) {
        if secretPhraseValidate(toCompare: item) {
            walletError = false
        }
        let seed = Mnemonic.createSeed(mnemonic: item)
        switch type {
        case .ethereum:
            let wallet1 = Wallet(seed: seed, coin: .ethereum)
            _ = wallet1.generateAccount()
        case .bitcoin:
            let wallet1 = Wallet(seed: seed, coin: .bitcoin)
            _ = wallet1.generateAccount()
        case .aur:
            break
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
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

     private func secretPhraseValidate(toCompare: String) -> Bool {
        return toCompare == keychainService.secretPhrase
    }
}
