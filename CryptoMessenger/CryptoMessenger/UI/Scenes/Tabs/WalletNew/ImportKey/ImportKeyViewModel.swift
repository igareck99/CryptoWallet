import SwiftUI
import HDWalletKit
import Combine

// MARK: - ImportKeyViewModel

final class ImportKeyViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ImportKeySceneDelegate?
    @Published var walletError = false

    // MARK: - Private Properties

    @Published private(set) var state: ImportKeyFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ImportKeyFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ImportKeyFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

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

    func send(_ event: ImportKeyFlow.Event) {
        eventSubject.send(event)
    }

    func createWallet(item: String, type: WalletType) {
        walletError = false
        let mnemonic = item.lowercased().split(separator: " ")
        for x in mnemonic where !x.isEmpty {
            if WordList.english.words.contains(String(x)) == false {
                walletError = true
                return
            }
        }
        let seed = Mnemonic.createSeed(mnemonic: item)
        switch type {
        case .ethereum:
            let wallet1 = Wallet(seed: seed, coin: .ethereum)
            let account_wallet1 = wallet1.generateAccount()
        case .bitcoin:
            let wallet1 = Wallet(seed: seed, coin: .bitcoin)
            let account_wallet1 = wallet1.generateAccount()
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
