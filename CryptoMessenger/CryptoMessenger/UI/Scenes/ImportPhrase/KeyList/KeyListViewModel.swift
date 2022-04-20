import Combine
import SwiftUI

// MARK: - KeyListViewModel

final class KeyListViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: KeyListSceneDelegate?
    @Published var keysList: [KeyValueTypeItem] = [
        .init(value: "0x8396738b..4cb2a2a7ca6", type: "ETH, USDT"),
        .init(value: "mrG7g5qtte..fWar9MjYex9aDs", type: "BTC")
    ]

    // MARK: - Private Properties

    @Published private(set) var state: KeyListFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<KeyListFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<KeyListFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userCredentialsStorage: UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		userCredentialsStorage: UserCredentialsStorage
	) {
		self.userCredentialsStorage = userCredentialsStorage
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: KeyListFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

	private func bindInput() {
		eventSubject
			.sink { [weak self] event in
				switch event {
				case .onAppear:
					self?.updateData()
					self?.objectWillChange.send()
				case .onImportKey:
					self?.delegate?.handleNextScene(.importKey)
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

// MARK: - KeyValueTypeItem

struct KeyValueTypeItem: Identifiable, Hashable {

    // MARK: - Internal Properties

    let id = UUID()
    let value: String
    let type: String
}
