import SwiftUI
import Combine

// MARK: - GroupChatSelectContactViewModel

final class GroupChatSelectContactViewModel: ObservableObject {

    @Published var isButtonAvailable = false
    @Published var users: [SelectContact] = []
    @Published var usersViews: [any ViewGeneratable] = []
    @Published var text = ""
    @Published var usersForCreate: [any ViewGeneratable] = []
    @Published var usersForCreateItems: [SelectContactChipsItem] = []
    var chatData: ChatData
    let resources: SelectContactResourcable.Type
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    private let config: ConfigType
    private(set) var contactsUseCase = ContactsUseCase.shared
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(coordinator: ChatCreateFlowCoordinatorProtocol?,
         config: ConfigType = Configuration.shared,
         resources: SelectContactResourcable.Type = SelectContactResources.self) {
        self.coordinator = coordinator
        self.resources = resources
        self.config = config
        self.chatData = ChatData.emptyObject()
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
        self.coordinator?.createGroupChat(chatData)
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
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [self] value in
                if !value.isEmpty {
                    self.usersViews = self.users.filter({ $0.name.contains(value) || $0.mxId.contains(value) })
                } else {
                    self.usersViews = self.users
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
                        print("s,asklaklsalks  \(result)")
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
                                      name: data.name, phone: data.phone,
                                      isSelected: !data.isSelected) { value in
            vibrate()
            self.onChangeState(value)
        }
        self.users[index] = newObject
        self.usersViews = self.users
        self.text = self.text
        usersForCreateItems = self.users.filter({ $0.isSelected == true }).map {
            let result = SelectContactChipsItem(mxId: $0.mxId,
                                                name: $0.name)
            return result
        }
        withAnimation(.easeOut(duration: 0.25)) {
            self.usersForCreate = usersForCreateItems
        }
    }
}
