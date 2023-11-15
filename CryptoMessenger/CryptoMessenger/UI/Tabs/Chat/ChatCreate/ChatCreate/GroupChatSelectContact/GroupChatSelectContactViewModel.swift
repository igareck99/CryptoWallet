import SwiftUI
import Combine

// MARK: - GroupChatSelectContactViewModel

final class GroupChatSelectContactViewModel: ObservableObject {

    @Published var isButtonAvailable = false
    @Published var users: [SelectContact] = []
    @Published var findedUsers: [SelectContact] = []
    @Published var usersViews: [any ViewGeneratable] = []
    @Published var text = ""
    @Published var usersForCreate: [any ViewGeneratable] = []
    @Published var usersForCreateItems: [SelectContactChipsItem] = []
    var chatData: ChatData
    let resources: SelectContactResourcable.Type
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    private let config: ConfigType
    private let matrixUseCase: MatrixUseCaseProtocol
    private(set) var contactsUseCase = ContactsUseCase.shared
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(coordinator: ChatCreateFlowCoordinatorProtocol?,
         config: ConfigType = Configuration.shared,
         matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
         resources: SelectContactResourcable.Type = SelectContactResources.self) {
        self.coordinator = coordinator
        self.resources = resources
        self.config = config
        self.chatData = ChatData.emptyObject()
        self.matrixUseCase = matrixUseCase
        self.syncContacts()
        self.bindInput()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func onFinish() {
        let data = self.users.filter({ $0.isSelected == true })
        let result: [Contact] = data.map {
            let contact = Contact(mxId: $0.mxId,
                                  name: $0.name,
                                  status: "", phone: $0.phone, onTap: { _ in
            })
            return contact
        }
        chatData.contacts = result
        self.coordinator?.createGroupChat(chatData, result)
    }

    func getButtonColor() -> Color {
        if isButtonAvailable {
            return resources.textColor
        }
        return resources.buttonBackground
    }
    
    // MARK: - Private Methods
    
    private func bindInput() {
        $text
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [self] value in
                if !value.isEmpty {
                    let group = DispatchGroup()
                    group.enter()
                    self.matrixUseCase.searchUser(text) { name in
                        if let name = name {
                            let contact = SelectContact(mxId: text,
                                                        avatar: nil,
                                                        name: name,
                                                        phone: "",
                                                        isSelected: false,
                                                        sourceType: .finded) { value in
                                self.onChangeState(value)
                            }
                            let ids = self.users.map {
                                return $0.mxId
                            }
                            if ids.contains(contact.mxId) {
                                return
                            }
                            self.users.append(contact)
                            self.usersViews = self.users
                        } else {
                            self.usersViews = self.users.filter({ $0.sourceType != .finded })
                        }
                        group.leave()
                    }
                    group.notify(queue: .main) {
                        self.usersViews = self.users.filter({ $0.name.contains(value) || $0.mxId.contains(value) })
                    }
                } else {
                    print("slkaslaslasl  \(self.users)")
                    self.usersViews = self.users.filter({ $0.sourceType != .finded  })
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
    }

    private func syncContacts() {
        contactsUseCase.syncContacts { state in
            switch state {
            case .allowed:
                self.contactsUseCase.reuqestUserContacts { contact in
                    self.contactsUseCase.matchServerContacts(contact, .groupCreate) { result in
                        self.setData(result)
                    } onTap: { _ in
                    }
                }
                return
            case .notDetermined:
                self.contactsUseCase.requestContactsAccess { isAllowed in
                    if isAllowed {
                        self.contactsUseCase.reuqestUserContacts { contact in
                            self.contactsUseCase.matchServerContacts(contact, .groupCreate) { result in
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
        self.users = result.map {
            let data = SelectContact(mxId: $0.mxId,
                                     avatar: $0.avatar,
                                     name: $0.name,
                                     phone: $0.phone,
                                     isSelected: false, onTap: { value in
                self.onChangeState(value)
            })
            return data
        }
        self.usersViews = self.users
    }
    
    private func onChangeState(_ data: SelectContact) {
        guard let index = self.users.firstIndex(where: { $0.mxId == data.mxId }) else {
            return
        }
        let newObject = SelectContact(mxId: data.mxId, avatar: data.avatar,
                                      name: data.name, phone: data.phone,
                                      isSelected: !data.isSelected, sourceType: data.sourceType) { value in
            vibrate()
            self.onChangeState(value)
        }
        self.users[index] = newObject
        if text.isEmpty {
            self.usersViews = self.users.filter({ $0.sourceType != .finded })
        } else {
            self.usersViews = self.users.filter({ $0.name.contains(text) || $0.mxId.contains(text) })
        }
        usersForCreateItems = self.users.filter({ $0.isSelected == true }).map { value in
            let result = SelectContactChipsItem(mxId: value.mxId,
                                                name: value.name) {
                self.removeChips(value)
            }
            return result
        }
        withAnimation(.easeOut(duration: 0.25)) {
            self.usersForCreate = usersForCreateItems
        }
    }
    
    private func removeChips(_ data: SelectContact) {
        guard let item = self.users.first(where: { $0.mxId == data.mxId && $0.name == data.name }) else {
            return
        }
        let newObject = SelectContact(mxId: item.mxId, avatar: item.avatar,
                                      name: item.name, phone: item.phone,
                                      isSelected: true, sourceType: item.sourceType) { _ in
        }
        self.onChangeState(newObject)
    }
}
