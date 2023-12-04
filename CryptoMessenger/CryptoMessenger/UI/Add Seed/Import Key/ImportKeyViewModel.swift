import Combine
import SwiftUI

protocol ImportKeyCoordinatable {
    func didImportKey()
}

protocol ImportKeyViewModelProtocol: ObservableObject {
    var isPhraseValid: Bool { get set }
    var isErrorState: Bool { get set }
    var newKey: String { get set }
    var isSnackbarPresented: Bool { get set }
    var resources: ImportKeyResourcable.Type { get }

    func createWallet(item: String)
    func onAddressImported()
}

final class ImportKeyViewModel {

    // MARK: - Internal Properties

    @Published var isPhraseValid = false
    @Published var isErrorState = false
    @Published var newKey = ""
    @Published var isSnackbarPresented = false
    let resources: ImportKeyResourcable.Type

    // MARK: - Private Properties

    private let coordinator: ImportKeyCoordinatable
    private var keychainService: KeychainServiceProtocol
    private let phraseService: PhraseServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
        coordinator: ImportKeyCoordinatable,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        phraseService: PhraseServiceProtocol = PhraseService.shared,
        resources: ImportKeyResourcable.Type = ImportKeyResources.self
    ) {
        self.resources = resources
        self.coordinator = coordinator
        self.keychainService = keychainService
        self.phraseService = phraseService
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Private Methods

    private func bindInput() {
        $newKey
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if value.isEmpty {
                    self.isPhraseValid = false
                    self.isErrorState = false
                } else {
                    let result = self.phraseService.validateSecretPhrase(phrase: value)
                    self.isPhraseValid = result
                    self.isErrorState = !result
                }
            }.store(in: &subscriptions)
    }
}

// MARK: - ImportKeyViewModelProtocol

extension ImportKeyViewModel: ImportKeyViewModelProtocol {

    func createWallet(item: String) {
        keychainService.secretPhrase = item
    }

    func onAddressImported() {
        isSnackbarPresented = true
        objectWillChange.send()

        delay(3) { [weak self] in
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
            delay(0.7) { [weak self] in
                self?.coordinator.didImportKey()
            }
        }
    }
}
