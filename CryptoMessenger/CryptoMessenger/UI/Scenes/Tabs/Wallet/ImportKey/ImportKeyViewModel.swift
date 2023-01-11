import SwiftUI
import Combine
import HDWalletKit

// MARK: - ImportKeyViewModel

final class ImportKeyViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ImportKeySceneDelegate?
    var viewState: ImportKeyViewState = .reserveCopy
    @Published var walletError = false
    @Published var newKey = ""

    // MARK: - Private Properties

    @Published private(set) var state: ImportKeyFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ImportKeyFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ImportKeyFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private var keychainService: KeychainServiceProtocol
	private let coreDataService: CoreDataServiceProtocol
    private let phraseService: PhraseServiceProtocol
	var walletTypes = [WalletType]()

    // MARK: - Lifecycle

    init(
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        phraseService: PhraseServiceProtocol = PhraseService.shared
    ) {
        self.coreDataService = coreDataService
        self.keychainService = keychainService
        self.phraseService = phraseService
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

    func createWallet(item: String) {
        keychainService.secretPhrase = item
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                    self?.walletError = false
                    self?.getWallets()
                }
            }
            .store(in: &subscriptions)
        $newKey
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.phraseService.validateSecretPhrase(phrase: value, completion: { result in
                    self?.walletError = result
                })
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

	private func getWallets() {
		walletTypes = coreDataService.getWalletsTypes()
	}
}

// MARK: - ImportKeyViewState

enum ImportKeyViewState {
    case reserveCopy
    case importKey
}
