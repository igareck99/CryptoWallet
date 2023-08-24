import Combine
import SwiftUI

// MARK: - SelectContactViewModel

final class SelectContactViewModel: ObservableObject, SelectContactViewModelDelegate {

    // MARK: - Internal Properties

    @Published var isButtonAvailable = false
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var state: SelectContactFlow.ViewState = .idle
    @Published var users: [SelectContact] = []
    @Published var userForSend: [Contact] = []
    @Published var usersViews: [any ViewGeneratable] = []
    var mode: ContactViewMode
    @Published var searchText = ""
    var contactsLimit: Int?
    var chatData: ChatData
    var onUsersSelected: ([Contact]) -> Void
    let resources: SelectContactResourcable.Type = SelectContactResources.self
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    var chatHistoryCoordinator: ChatHistoryFlowCoordinatorProtocol?
    private let config: ConfigType

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SelectContactFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SelectContactFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private(set) var contactsUseCase = ContactsUseCase.shared

    // MARK: - Lifecycle

    init(
        mode: ContactViewMode = .send,
        contactsLimit: Int? = nil,
        onUsersSelected: @escaping ([Contact]) -> Void,
        config: ConfigType = Configuration.shared,
        resources: SelectContactResourcable.Type = SelectContactResources.self
    ) {
        self.mode = mode
        self.contactsLimit = contactsLimit
        self.config = config
        self.chatData = ChatData.emptyObject()
        self.onUsersSelected = onUsersSelected
        bindInput()
        bindOutput()
        getContacts()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: SelectContactFlow.Event) {
        eventSubject.send(event)
    }

    func getButtonColor() -> Color {
        if isButtonAvailable {
            return resources.textColor
        }
        return resources.buttonBackground
    }

    func dismissSheet() {
        chatHistoryCoordinator?.dismissCurrentSheet()
    }

    func onFinish() {
        let data = self.users.filter({ $0.isSelected == true })
        let result: [Contact] = data.map {
            let contact = Contact(mxId: $0.mxId,
                                  name: $0.name,
                                  status: "", onTap: { _ in
            })
            return contact
        }
        switch mode {
        case .send:
            break
        case .add:
            self.onUsersSelected(result)
        case .groupCreate:
            let data = self.users.filter({ $0.isSelected == true })
            let result: [Contact] = data.map {
                let contact = Contact(mxId: $0.mxId,
                                      name: $0.name,
                                      status: "", onTap: { _ in
                })
                return contact
            }
            chatData.contacts = result
            self.coordinator?.createGroupChat(chatData)
        case .admins:
            break
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.syncContacts()
                }
            }
            .store(in: &subscriptions)
        $users
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                let new = data.filter({ $0.isSelected })
                self?.isButtonAvailable = new.isEmpty
            }
            .store(in: &subscriptions)
        $searchText
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [self] value in
                if !value.isEmpty {
                    self.usersViews = self.userForSend.filter({ $0.name.contains(value) || $0.phone.contains(value) })
                } else {
                    self.usersViews = self.userForSend
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getContacts() {
        contacts = contactsUseCase.getContacts()
    }

    private func syncContacts() {
        contactsUseCase.syncContacts { state in
            switch state {
            case .allowed:
                self.contactsUseCase.reuqestUserContacts { contact in
                    self.contactsUseCase.matchServerContacts(contact, self.mode) { result in
                        self.setData(result)
                    } onTap: { _ in
                    }
                }
                return
            case .notDetermined:
                self.contactsUseCase.requestContactsAccess { isAllowed in
                    if isAllowed {
                        self.contactsUseCase.reuqestUserContacts { contact in
                            self.contactsUseCase.matchServerContacts(contact, self.mode) { result in
                                self.setData(result)
                            } onTap: { _ in
                            }
                        }
                    }
                }
                return
            case .restricted, .denied, .unknown:
                break
            }
        }
    }

    private func setData(_ result: [Contact]) {
        switch mode {
        case .send:
            let contacts = result.filter({ $0.type == .waitingContacts })
            self.userForSend = contacts.map {
                let contact = Contact(mxId: $0.mxId,
                                      name: $0.name,
                                      status: $0.status,
                                      phone: $0.phone,
                                      type: .sendContact) { result in
                    self.onUsersSelected([result])
                    self.chatHistoryCoordinator?.dismissCurrentSheet()
                }
                return contact
            }
            self.usersViews = self.userForSend
        default:
            let contacts = result.filter({ $0.type == .lastUsers })
            self.users = contacts.map {
                let data = SelectContact(mxId: $0.mxId,
                                         avatar: $0.avatar,
                                         name: $0.name,
                                         phone: $0.phone,
                                         isSelected: false, onTap: { value in
                    vibrate()
                    self.onChangeState(value)
                })
                return data
            }
            self.usersViews = self.users
        }
    }

    private func onChangeState(_ data: SelectContact) {
        guard let index = self.users.firstIndex(where: { $0.mxId == data.mxId }) else { return }
        let newObject = SelectContact(mxId: data.mxId, avatar: data.avatar,
                                      name: data.name, phone: data.phone,
                                      isSelected: !data.isSelected) { value in
            vibrate()
            self.onChangeState(value)
        }
        self.users[index] = newObject
        self.usersViews = self.users
    }
}
