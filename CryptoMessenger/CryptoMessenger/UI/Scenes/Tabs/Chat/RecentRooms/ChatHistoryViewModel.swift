import Combine
import UIKit

// MARK: - ChatHistoryViewModel

final class ChatHistoryViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChatHistorySceneDelegate?

    @Published private(set) var rooms: [AuraRoom] = []
    @Published private(set) var state: ChatHistoryFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatHistoryFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatHistoryFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var mxStore: MatrixStore

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

    func send(_ event: ChatHistoryFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.rooms = self?.mxStore.rooms ?? []
                    self?.objectWillChange.send()
                case let .onShowRoom(room):
                    self?.delegate?.handleNextScene(.chatRoom(room))
                case let .onDeleteRoom(roomId):
                    self?.mxStore.leaveRoom(roomId: roomId, completion: { _ in })
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rooms = self?.mxStore.rooms ?? []
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
