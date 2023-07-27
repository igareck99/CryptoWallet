import Combine
import SwiftUI

// MARK: - GeneratePhraseViewModel

final class GeneratePhraseViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: GeneratePhraseSceneDelegate?
    @Published var generatePhraseState: GeneratePhraseState = .generate
    @Published var generatedKey = ""
    @Published var isAnimated = false
    var isSnackbarPresented = false
    var buttonState: ViewState = .content
    var firstStart = false
    let resources: GeneratePhraseResourcable.Type = GeneratePhraseResources.self

    // MARK: - Private Properties

    @Published private(set) var state: GeneratePhraseFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<GeneratePhraseFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<GeneratePhraseFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let phraseService: PhraseServiceProtocol
    private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(generatePhraseState: GeneratePhraseState = .generate,
         phraseService: PhraseServiceProtocol = PhraseService.shared,
         keychainService: KeychainServiceProtocol = KeychainService.shared,
         resources: GeneratePhraseResourcable.Type = GeneratePhraseResources.self
    ) {
        self.generatePhraseState = generatePhraseState
        self.phraseService = phraseService
        self.keychainService = keychainService
        bindInput()
        bindOutput()
    }

    // MARK: - Internal Methods

    func send(_ event: GeneratePhraseFlow.Event) {
        eventSubject.send(event)
    }

    func onPhraseCopy() {
        isSnackbarPresented = true
        objectWillChange.send()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }

    func toggleState(_ state: ButtonGeneratePhraseState) {
        if generatePhraseState == .generate {
            generatePhraseState = .warning
        } else if generatePhraseState == .warning {
            if state == .create {
                isAnimated = true
                self.phraseService.createMnemonicPhrase() { value in
                    self.generatedKey = value
                    self.keychainService.secretPhrase = value
                }
                delay(2) {
                    self.isAnimated = false
                    self.generatePhraseState = .watchKey
                }
            } else {
                self.generatePhraseState = .importKey
            }
        }
        self.objectWillChange.send()
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

// MARK: - GeneratePhraseState

enum GeneratePhraseState {

    case generate
    case warning
    case watchKey
    case importKey
}

// MARK: - GeneratePhraseState

enum ButtonGeneratePhraseState {

    case create
    case importing
}
