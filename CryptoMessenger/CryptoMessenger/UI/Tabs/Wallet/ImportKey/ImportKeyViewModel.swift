import Combine
import SwiftUI
import HDWalletKit

// MARK: - ImportKeyViewModel

final class ImportKeyViewModel: ObservableObject {

    // MARK: - Internal Properties

    private let coordinator: WalletCoordinatable
    var viewState: ImportKeyViewState = .reserveCopy
    @Published var isPhraseValid = false
    @Published var isErrorState = false
    @Published var newKey = ""
    @Published var isCheckPhrase = false
    var isSnackbarPresented = false

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
        coordinator: WalletCoordinatable,
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        phraseService: PhraseServiceProtocol = PhraseService.shared
    ) {
        self.coordinator = coordinator
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

    func onAddressImported() {
        isSnackbarPresented = true
        objectWillChange.send()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.coordinator.didImportKey()
            }
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                    self?.isPhraseValid = false
                    self?.getWallets()
                }
            }
            .store(in: &subscriptions)
        $newKey
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if value.isEmpty {
                    self.isPhraseValid = false
                    self.isErrorState = false
                } else {
                    let result = self.phraseService.validateSecretPhrase(phrase: value)
                    debugPrint("validateSecretPhrase: \(result)")
                    self.isPhraseValid = result
                    self.isErrorState = !result
                }
            }.store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

	private func getWallets() {
		walletTypes = coreDataService.getNetworkTokensWalletsTypes()
	}
}

// MARK: - ImportKeyViewState

enum ImportKeyViewState {
    case reserveCopy
    case importKey
}
