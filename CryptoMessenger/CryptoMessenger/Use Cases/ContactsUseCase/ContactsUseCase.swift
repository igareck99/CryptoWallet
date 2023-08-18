import Combine

// MARK: - ContactsUseCase

final class ContactsUseCase {

    // MARK: - Static Properties

    static let shared = ContactsUseCase()

    // MARK: - Private Properties

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var contactsStore: ContactsManager
    private let config: ConfigType
    private let contactsFactory: ContactsObjectFactoryProtocol = ContactsObjectFactory()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(config: ConfigType = Configuration.shared) {
        self.config = config
    }

    // MARK: - Internal Properties

    func getContacts() -> [Contact] {
        let users = matrixUseCase.allUsers()
        let contacts = users.map {
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
        return contacts
    }

    func syncContacts(completion: @escaping (AccessState) -> Void) {
        let contactsAccessState = contactsStore.reuqestContactsAccessState()
        completion(contactsAccessState)
    }

    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        contactsStore.requestContactsAccess { isAllowed in
            guard isAllowed else { return }
            completion(isAllowed)
        }
    }

    func reuqestUserContacts(completion: @escaping ([ContactInfo]) -> Void) {
        contactsStore.fetchContacts { [weak self] result in
            guard case let .success(userContacts) = result else { return }
            completion(userContacts)
        }
    }
    
    func matchServerContacts(_ contacts: [ContactInfo],
                             _ mode: ContactViewMode,
                             completion: @escaping ([Contact]) -> Void) {
        guard !contacts.isEmpty else { return }
        let phones = contacts.map { $0.phoneNumber.numbers }
        apiClient.publisher(Endpoints.Users.users(phones))
            .replaceError(with: [:])
            .sink { response in
                let mxUsers: [MXUser] = self.matrixUseCase.allUsers() ?? []
                let lastUsers = self.contactsFactory.makeLastUsersContacts(contacts: contacts,
                                                                      matrixUseCase: self.matrixUseCase,
                                                                      config: self.config,
                                                                      data: response)

                let existing = self.contactsFactory.makeExisitingContacts(contacts: contacts,
                                                                     config: self.config,
                                                                     lastUsers: lastUsers,
                                                                     data: response)
                var existingContacts = lastUsers + existing
                if mode == .send {
                    let waitingContacts = self.contactsFactory.makeWaitingContacts(contacts: contacts,
                                                                              lastUsers: lastUsers,
                                                                              data: response)
                    existingContacts += waitingContacts
                }
                completion(existingContacts)
            }
            .store(in: &subscriptions)
    }
}
