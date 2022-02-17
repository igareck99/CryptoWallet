import Combine
import Foundation
import MatrixSDK

// MARK: - Contact

struct Contact: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let mxId: String
    var avatar: URL?
    let name: String
    let status: String
    var phone = ""
}

// MARK: - ChatCreateViewModel

final class ChatCreateViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var searchText = ""
    @Published var searching = false
    @Published private(set) var closeScreen = false
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var state: ChatCreateFlow.ViewState = .idle
    @Published private(set) var existingContacts: [Contact] = []
    @Published private(set) var waitingContacts: [Contact] = []

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var contactsStore: ContactsManager
    @Injectable private var apiClient: APIClientManager

    // MARK: - Lifecycle

    init() {
        bindInput()
        bindOutput()
        getContacts(mxStore.allUsers())
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
                    self?.syncContacts()
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

        $searchText
            .debounce(for: 0.05, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.mxStore.searchUser(text) { name in
                    if let name = name {
                        self?.contacts.append(
                            .init(
                                mxId: text,
                                avatar: nil,
                                name: name,
                                status: ""
                            )
                        )

                    }
                }
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
            parameters.inviteArray = ids
            parameters.isDirect = false
            parameters.roomAlias = mxStore.getUserId()
            parameters.name = "Групповой чат"
            parameters.topic = "Тема"
            parameters.visibility = MXRoomDirectoryVisibility.private.identifier
            parameters.preset = MXRoomPreset.privateChat.identifier
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

    private func getContacts(_ users: [MXUser]) {
        contacts = users.map {
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
    }

    private func syncContacts() {
        contactsStore.fetch { [weak self] contacts, _ in
            self?.matchServerContacts(contacts)
        }
    }

    private func matchServerContacts(_ contacts: [ContactInfo]) {
        guard !contacts.isEmpty else { return }

        let phones = contacts.map { $0.phoneNumber.numbers }

        apiClient.publisher(Endpoints.Users.users(phones))
            .replaceError(with: [:])
            .sink { [weak self] response in
                let sorted = contacts.sorted(by: { $0.firstName < $1.firstName })

                let mxUsers: [MXUser] = self?.mxStore.allUsers() ?? []
                let lastUsers: [Contact] = mxUsers
                    .filter { $0.userId != self?.mxStore.getUserId() }
                    .map {
                        var contact = Contact(
                            mxId: $0.userId ?? "",
                            avatar: nil,
                            name: $0.displayname ?? "",
                            status: $0.statusMsg ?? "Привет, теперь я в Aura"
                        )
                        if let avatar = $0.avatarUrl {
                            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                            contact.avatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
                        }
                        return contact
                    }

                let existing: [Contact] = sorted
                    .filter { response.keys.contains($0.phoneNumber.numbers) }
                    .map {
                        .init(
                            mxId: response[$0.phoneNumber] ?? "",
                            avatar: nil,
                            name: $0.firstName,
                            status: "Привет, теперь я в Aura"
                        )
                    }
                    .filter { contact in
                        !lastUsers.contains(where: { last in
                            contact.mxId == last.mxId
                        })
                    }

                self?.existingContacts = lastUsers + existing

                self?.waitingContacts = sorted.filter { !response.keys.contains($0.phoneNumber.numbers) }.map {
                    .init(
                        mxId: response[$0.phoneNumber] ?? "",
                        avatar: nil,
                        name: $0.firstName,
                        status: "",
                        phone: $0.phoneNumber
                    )
                }
            }
            .store(in: &subscriptions)
    }
}
