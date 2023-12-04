import Combine
import SwiftUI

protocol GeneratePhraseSceneDelegate: AnyObject {
    func handleNextScene()
}

protocol PhraseGeneratable: AnyObject {
    func onImportTap()
    func update(router: GeneratePhraseRouterable)
    func showPhrase(seed: String)
}

extension PhraseGeneratable {
    func update(router: GeneratePhraseRouterable) {}
}

protocol GeneratePhraseViewModelProtocol: ObservableObject {
    var isBackButtonHidden: Bool { get set }
    var generatedKey: String { get set }
    var isAnimated: Bool { get set }
    var resources: GeneratePhraseResourcable.Type { get }
    var isSnackbarPresented: Bool { get set }

    func onImportKeyTap()
    func onCreateKeyTap()
}

final class GeneratePhraseViewModel {

    weak var delegate: GeneratePhraseSceneDelegate?
    @Published var isBackButtonHidden = false
    @Published var generatedKey = ""
    @Published var isAnimated = false
    @Published var isSnackbarPresented = false
    let resources: GeneratePhraseResourcable.Type
    private let coordinator: PhraseGeneratable
    private var subscriptions = Set<AnyCancellable>()
    private let phraseService: PhraseServiceProtocol
    private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
        coordinator: PhraseGeneratable,
        isBackButtonHidden: Bool = false,
        phraseService: PhraseServiceProtocol = PhraseService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        resources: GeneratePhraseResourcable.Type = GeneratePhraseResources.self
    ) {
        self.coordinator = coordinator
        self.isBackButtonHidden = isBackButtonHidden
        self.phraseService = phraseService
        self.keychainService = keychainService
        self.resources = resources
    }
}

// MARK: - GeneratePhraseViewModelProtocol

extension GeneratePhraseViewModel: GeneratePhraseViewModelProtocol {

    func onImportKeyTap() {
        coordinator.onImportTap()
    }

    func onCreateKeyTap() {
        let phrase = phraseService.createMnemonicPhrase()
        keychainService.secretPhrase = phrase
        generatedKey = phrase
        coordinator.showPhrase(seed: phrase)
    }
}
