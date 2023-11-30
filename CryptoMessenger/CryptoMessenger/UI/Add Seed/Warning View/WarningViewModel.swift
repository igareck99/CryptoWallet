import Foundation

protocol WarningViewModelDelegate {
    func showSeedPhrase(seed: String)
    func cancelCreation()
}

protocol WarningViewProtocol: ObservableObject {
    var animateProceedButton: Bool { get set }
    var resources: WarningViewResourcable.Type { get }

    func onProceedTap()
    func onCancelTap()
}

final class WarningViewModel {

    @Published var animateProceedButton = false
    let keychainService: KeychainServiceProtocol
    let phraseService: PhraseServiceProtocol
    let coordinator: WarningViewModelDelegate
    let resources: WarningViewResourcable.Type

    init(
        coordinator: WarningViewModelDelegate,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        phraseService: PhraseServiceProtocol = PhraseService.shared,
        resources: WarningViewResourcable.Type = WarningViewResources.self
    ) {
        self.coordinator = coordinator
        self.keychainService = keychainService
        self.phraseService = phraseService
        self.resources = resources
    }
}

// MARK: - WarningViewProtocol

extension WarningViewModel: WarningViewProtocol {
    func onProceedTap() {
        animateProceedButton = true
        let phrase = phraseService.createMnemonicPhrase()
        keychainService.secretPhrase = phrase
        delay(2) {
            self.animateProceedButton = true
            self.coordinator.showSeedPhrase(seed: phrase)
        }
    }

    func onCancelTap() {
        coordinator.cancelCreation()
    }
}
