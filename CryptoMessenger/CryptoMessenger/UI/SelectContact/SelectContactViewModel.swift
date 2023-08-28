import Combine
import SwiftUI

// MARK: - SelectContactViewModel

final class SelectContactViewModel: ObservableObject, SelectContactViewModelDelegate {

    // MARK: - Internal Properties

    @Published private(set) var closeScreen = false
    @Published var isButtonAvailable = false
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var state: SelectContactFlow.ViewState = .idle
    @Published private(set) var existingContacts: [Contact] = []
    @Published private(set) var waitingContacts: [Contact] = []
    @Published var users: [SelectContact] = []
    @Published var usersViews: [any ViewGeneratable] = []
    let mode: ContactViewMode
    var contactsLimit: Int?
    var chatData: ChatData
    var onSelectContact: GenericBlock<[Contact]>?
    let resources: SelectContactResourcable.Type = SelectContactResources.self
    var coordinator: ChatCreateFlowCoordinatorProtocol?
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
        onSelectContact: GenericBlock<[Contact]>? = nil,
        config: ConfigType = Configuration.shared,
        resources: SelectContactResourcable.Type = SelectContactResources.self
    ) {
        self.mode = mode
        self.contactsLimit = contactsLimit
        self.config = config
        self.chatData = ChatData.emptyObject()
        self.onSelectContact = onSelectContact
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
        case .send, .groupCreate:
            chatData.contacts = result
            self.coordinator?.createGroupChat(chatData)
        case .add, .admins:
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
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                let new = data.filter({ $0.isSelected })
                self?.isButtonAvailable = new.isEmpty
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
                    } onTap: { value in
                        print("slaslklsaklkas  \(value)")
                    }
                }
                return
            case .notDetermined:
                self.contactsUseCase.requestContactsAccess { isAllowed in
                    if isAllowed {
                        self.contactsUseCase.reuqestUserContacts { contact in
                            self.contactsUseCase.matchServerContacts(contact, self.mode) { result in
                                self.setData(result)
                            } onTap: { value in
                                print("slaslklsaklkas  \(value)")
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
        let contacts = result.filter({ $0.type == .lastUsers })
        self.users = contacts.map {
            let data = SelectContact(mxId: $0.mxId,
                                     avatar: $0.avatar,
                                     name: $0.name,
                                     isSelected: false, onTap: { value in
                vibrate()
                self.onChangeState(value)
            })
            return data
        }
        self.usersViews = self.users
    }

    private func onChangeState(_ data: SelectContact) {
        guard let index = self.users.firstIndex(where: { $0.mxId == data.mxId }) else { return }
        let newObject = SelectContact(mxId: data.mxId, avatar: data.avatar,
                                      name: data.name, isSelected: !data.isSelected) { value in
            vibrate()
            self.onChangeState(value)
        }
        self.users[index] = newObject
        self.usersViews = self.users
    }
}
