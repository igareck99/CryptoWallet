import Combine
import UIKit

// MARK: - ChatHistoryViewModel

final class ChatHistoryViewModel: ObservableObject, ChatHistoryViewDelegate {

    weak var delegate: ChatHistorySceneDelegate?

	let eventSubject = PassthroughSubject<ChatHistoryFlow.Event, Never>()
	let sources: ChatHistorySourcesable.Type

    @Published private(set) var rooms: [AuraRoom] = []
    @Published private(set) var state: ChatHistoryFlow.ViewState = .idle
    @Published var groupAction: GroupAction?
    @Published var translateAction: TranslateAction?
    @Published var isFromCurrentUser = false
    @Published var roomsLastCurrent: [String: Bool] = [:]

    // MARK: - Private Properties

    private let stateValueSubject = CurrentValueSubject<ChatHistoryFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol

    // MARK: - Lifecycle

    init(
		sources: ChatHistorySourcesable.Type = ChatHistorySources.self
	) {
		self.sources = sources
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

	// MARK: - ChatHistoryViewDelegate

	func rooms(with filter: String) -> [AuraRoom] {
		filter.isEmpty ? rooms : rooms.filter {
			$0.summary.displayname.lowercased().contains(filter.lowercased())
			|| $0.summary.topic?.lowercased().contains(filter.lowercased()) ?? false
		}
	}

	func markAllAsRead() {
		for room in rooms {
			room.markAllAsRead()
		}
	}

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
					debugPrint("MatrixService: ChatHistoryViewModel rooms: \(self?.matrixUseCase.rooms)")
                    self?.rooms = self?.matrixUseCase.rooms ?? []
                    self?.objectWillChange.send()
                case let .onShowRoom(room):
                    self?.delegate?.handleNextScene(.chatRoom(room))
                case let .onDeleteRoom(roomId):
                    self?.matrixUseCase.leaveRoom(roomId: roomId, completion: { _ in })
                }
            }
            .store(in: &subscriptions)

		matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
				debugPrint("MatrixService: matrixUseCase.rooms: \(self?.matrixUseCase.rooms ?? [])")
                self?.rooms = self?.matrixUseCase.rooms ?? []
            }
            .store(in: &subscriptions)
    }

    func fromCurrentSender(room: AuraRoom) -> Bool {
        let event = room.events().renderableEvents.filter({ !$0.eventId.contains("kMXEventLocalId") })
        let lastEvent = event.first
        guard let str = lastEvent?.eventId else { return false }
        return matrixUseCase.fromCurrentSender(str)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
