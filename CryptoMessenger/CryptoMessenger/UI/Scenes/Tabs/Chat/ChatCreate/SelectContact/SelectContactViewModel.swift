import Combine

// MARK: - SelectContactViewModel

final class SelectContactViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published private(set) var closeScreen = false
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var state: SelectContactFlow.ViewState = .idle
    @Published private(set) var existingContacts: [Contact] = []
    @Published private(set) var waitingContacts: [Contact] = []
    let mode: ContactViewMode
    private let config: ConfigType

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SelectContactFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SelectContactFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var contactsStore: ContactsManager
    @Injectable private var apiClient: APIClientManager

    // MARK: - Lifecycle

    init(
        mode: ContactViewMode = .send,
        config: ConfigType = Configuration.shared
    ) {
        self.mode = mode
        self.config = config
        bindInput()
        bindOutput()
        getContacts(matrixUseCase.allUsers())
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: SelectContactFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.syncContacts()
                case .onNextScene:
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

    private func getContacts(_ users: [MXUser]) {
        contacts = users.map {
            var contact = Contact(
                mxId: $0.userId ?? "",
                avatar: nil,
                name: $0.displayname ?? "",
                status: $0.statusMsg ?? ""
            )
            if let avatar = $0.avatarUrl {
                let homeServer = config.matrixURL
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

                let mxUsers: [MXUser] = self?.matrixUseCase.allUsers() ?? []
                let lastUsers: [Contact] = mxUsers
                    .filter { $0.userId != self?.matrixUseCase.getUserId() }
                    .map {
                        var contact = Contact(
                            mxId: $0.userId ?? "",
                            avatar: nil,
                            name: $0.displayname ?? "",
                            status: $0.statusMsg ?? "Привет, теперь я в Aura"
                        )
                        if let avatar = $0.avatarUrl,
                           let homeServer = self?.config.matrixURL {
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
                            name: $0.firstName + " " + $0.lastName,
                            status: "Привет, теперь я в Aura",
                            phone: $0.phoneNumber
                        )
                    }
                    .filter { contact in
                        !lastUsers.contains(where: { $0.mxId == contact.mxId })
                    }

                self?.existingContacts = lastUsers + existing
                if self?.mode == .send {
                    self?.waitingContacts = sorted.filter { !response.keys.contains($0.phoneNumber.numbers) }.map {
                        .init(
                            mxId: response[$0.phoneNumber] ?? "",
                            avatar: nil,
                            name: $0.firstName + " " + $0.lastName,
                            status: "",
                            phone: $0.phoneNumber
                        )
                    }
                    self?.existingContacts += self?.waitingContacts ?? []
                }
            }
            .store(in: &subscriptions)
    }
}
