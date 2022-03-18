import Combine
import SwiftUI

final class ChooseReceiverViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChooseReceiverSceneDelegate?

    // MARK: - Private Properties

    @Published private(set) var state: ChooseReceiverFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ChooseReceiverFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChooseReceiverFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlows: UserFlowsStorageService

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

    func send(_ event: ChooseReceiverFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                case let .onScanner(scannedScreen):
                    self?.delegate?.handleNextScene(.scanner(scannedScreen))
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

// MARK: - SearchType

enum SearchType {

    // MARK: - Types

    case contact
    case telephone
    case wallet

    // MARK: - Internal Properties

    var result: String {
        switch self {
        case .contact:
            return R.string.localizable.chooseReceiverContact()
        case .telephone:
            return R.string.localizable.chooseReceiverTelephone()
        case .wallet:
            return R.string.localizable.chooseReceiverWallet()
        }
    }
}
