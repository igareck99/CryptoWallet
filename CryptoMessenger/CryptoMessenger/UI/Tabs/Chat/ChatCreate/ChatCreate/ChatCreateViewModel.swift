import Combine
import Foundation
import MatrixSDK

// MARK: - ChatData

struct ChatData {

    // MARK: - Internal Properties

    var title = ""
    var description = ""
    var image: UIImage?
    var contacts: [Contact] = []
    var showNotifications = false
    var media: [URL] = []
    var links: [URL] = []
    var documents: [URL] = []
    var admins: [Contact] = []
    var shareLink: URL?
    var isDirect = false
    var avatarUrl: URL?
}

// MARK: - Contact

struct Contact: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let mxId: String
    var avatar: URL?
    let name: String
    let status: String
    var phone = ""
    var isAdmin = false
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
    @Published private(set) var filteredContacts: [Contact] = []
    @Published private(set) var waitingContacts: [Contact] = []
    @Published private(set) var waitingFilteredContacts: [Contact] = []
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    let resources: ChatCreateResourcable.Type = ChatCreateResources.self

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var contactsStore: ContactsManager
    @Injectable private var apiClient: APIClientManager
    private let config: ConfigType

    // MARK: - Lifecycle

    init(
        config: ConfigType = Configuration.shared,
        resources: ChatCreateResourcable.Type = ChatCreateResources.self
    ) {
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

    func send(_ event: ChatCreateFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
					self?.state = .loading
                    self?.syncContacts()
                case let .onCreateDirect(ids):
                    self?.createDirectRoom(ids)
                case let .onCreateGroup(info):
                    self?.createGroupRoom(info)
                case .onNextScene:
                    ()
                }
            }
            .store(in: &subscriptions)

		matrixUseCase.objectChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &subscriptions)

        $searchText
            .debounce(for: 0.05, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.matrixUseCase.searchUser(text) { name in
                    if let name = name {
                        self?.filteredContacts = [.init(mxId: text, avatar: nil, name: name, status: "")]
                    } else {
                        if text.isEmpty {
                            self?.filteredContacts = []
                            self?.waitingFilteredContacts = []
                            return
                        }
                        self?.filteredContacts = self?.existingContacts.filter({
                            $0.name.lowercased().contains(text.lowercased())
                            || $0.phone.removeCharacters(from: "- ()").contains(text)
                            || $0.mxId.lowercased().contains(text.lowercased()) }) ?? []
                        self?.waitingFilteredContacts = self?.waitingContacts.filter({
                            $0.name.lowercased().contains(text.lowercased())
                            || $0.phone.removeCharacters(from: "- ()").contains(text)
                            || $0.mxId.lowercased().contains(text.lowercased()) }) ?? []
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

    private func createDirectRoom(_ ids: [String]) {
		guard
			ids.count == 1,
			let userId = ids.first,
			!matrixUseCase.isDirectRoomExists(userId: userId)
		else {
			closeScreen = true
			return
		}
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = ids
        parameters.isDirect = true
        parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        parameters.preset = MXRoomPreset.privateChat.identifier
        createRoom(parameters: parameters)
    }

    private func createGroupRoom(_ info: ChatData) {
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = info.contacts.map({ $0.mxId })
        parameters.isDirect = false
        parameters.name = info.title
        parameters.topic = info.description
        parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        parameters.preset = MXRoomPreset.privateChat.identifier
        createRoom(parameters: parameters, roomAvatar: info.image?.jpeg(.medium))
    }

    private func createRoom(parameters: MXRoomCreationParameters, roomAvatar: Data? = nil) {
		matrixUseCase.createRoom(parameters: parameters) { [weak self] response in
            switch response {
            case let .success(room):
                guard let data = roomAvatar else {
                    self?.closeScreen = true
                    return
                }

                self?.matrixUseCase.setRoomAvatar(data: data, for: room) { _ in
					// TODO: Обработать case failure
                    self?.closeScreen = true
                }
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
                let homeServer = config.matrixURL
                contact.avatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
            }
            return contact
        }
    }

	private func syncContacts() {
		let contactsAccessState = contactsStore.reuqestContactsAccessState()
		switch contactsAccessState {
		case .allowed:
			reuqestUserContacts()
			return
		case .notDetermined:
			contactsStore.requestContactsAccess { [weak self] isAllowed in
				guard isAllowed else { self?.state = .contactsAccessFailure; return }
				self?.reuqestUserContacts()
			}
			return
		case .restricted, .denied, .unknown:
			state = .contactsAccessFailure
		}
	}

	private func reuqestUserContacts() {
		contactsStore.fetchContacts { [weak self] result in
			guard case let .success(userContacts) = result else { self?.state = .contactsAccessFailure; return }
			self?.matchServerContacts(userContacts)
		}
	}

    private func matchServerContacts(_ contacts: [ContactInfo]) {

		guard !contacts.isEmpty else { state = .showContent; return }

        let phones = contacts.map { $0.phoneNumber.numbers }

        apiClient.publisher(Endpoints.Users.users(phones))
            .replaceError(with: [:])
            .sink { [weak self] response in
				self?.state = .showContent
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
                            name: $0.firstName,
                            status: "Привет, теперь я в Aura",
                            phone: $0.phoneNumber
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
