import Combine
import Foundation
import MatrixSDK

struct Contact: Identifiable {
    let id = UUID()
    let mxId: String
    var avatar: URL?
    let name: String
    let status: String
}

// MARK: - ChatCreateViewModel

final class ChatCreateViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChatCreateSceneDelegate?

    @Published private(set) var closeScreen = false
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var state: ChatCreateFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var mxStore: MatrixStore

    // MARK: - Lifecycle

    init() {
        contacts = mxStore.allUsers().map {
            var contact = Contact(
                mxId: $0.userId ?? "",
                avatar: nil,
                name: $0.displayname ?? "",
                status: $0.statusMsg ?? ""
            )
            if let avatar = $0.avatarUrl {
                let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                contact.avatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
            }
            return contact
        }

        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ChatCreateFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case let .onCreate(ids):
                    self?.createRoom(ids)
                case .onNextScene:
                    ()
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in

            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func createRoom(_ ids: [String]) {
        let parameters = MXRoomCreationParameters()
        if ids.count == 1 {
            parameters.inviteArray = ids
            parameters.isDirect = true
            parameters.visibility = MXRoomDirectoryVisibility.private.identifier
            parameters.preset = MXRoomPreset.privateChat.identifier
        } else {
            parameters.inviteArray = []
            parameters.isDirect = false
            parameters.name = ""
//            if isPublic {
//                parameters.visibility = MXRoomDirectoryVisibility.public.identifier
//                parameters.preset = MXRoomPreset.publicChat.identifier
//            } else {
//                parameters.visibility = MXRoomDirectoryVisibility.private.identifier
//                parameters.preset = MXRoomPreset.privateChat.identifier
//            }
        }

        mxStore.createRoom(parameters: parameters) { [weak self] response in
            switch response {
            case .success:
                self?.closeScreen = true
            case.failure:
                self?.closeScreen = true
            }
        }
    }
}
