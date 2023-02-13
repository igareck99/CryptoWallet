import Foundation
import Combine

// MARK: - ReservePhraseCopyViewModel

final class ReservePhraseCopyViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ReservePhraseCopySceneDelegate?
    var isSnackbarPresented = false
    @Published var generatedKey = ""
    let sources: ReserveCopyResourcable.Type = ReserveCopyResources.self

    // MARK: - Private Properties

    @Published private(set) var state: ReservePhraseCopyFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ReservePhraseCopyFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ReservePhraseCopyFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(keychainService: KeychainServiceProtocol = KeychainService.shared) {
        self.keychainService = keychainService
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ReservePhraseCopyFlow.Event) {
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

    // MARK: - Internal Methods

    func updateData() {
        guard let value = keychainService.secretPhrase else { return }
        generatedKey = value
    }
}
