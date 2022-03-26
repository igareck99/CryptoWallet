import Combine
import SwiftUI

// MARK: - PhraseManagerViewModel

final class PhraseManagerViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: PhraseManagerSceneDelegate?
    @Published var stepState = false
    @Published var stepText = ""
    @Published var title = ""
    @Published var description = ""
    @Published var secretPhrase = ""
    @Published var secretPhraseForApprove = ""

    // MARK: - Private Properties

    @Published private(set) var state: PhraseManagerFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<PhraseManagerFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<PhraseManagerFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

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

    func send(_ event: PhraseManagerFlow.Event) {
        eventSubject.send(event)
    }

    func updateStepText() {
        stepText = R.string.localizable.phraseManagerStepTwoOfTwo()
    }

    func updateTitleToWriteText() {
        title = R.string.localizable.phraseManagerWriteSecretPhrase()
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
        stepText = R.string.localizable.phraseManagerStepOneOfTwo()
        title = R.string.localizable.phraseManagerYourSecretPhrase()
        description = R.string.localizable.phraseManagerWriteAndEnter()
        secretPhrase = "symbol riot impact deny skirt  error error  design leave opera snap lava"
    }
}
