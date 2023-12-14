import Combine
import Foundation
import SwiftUI

protocol ChatCreateViewModelProtocol: ObservableObject {
    var actions: [any ViewGeneratable] { get set }

    func send(_ event: ChatCreateFlow.Event)
    
    func dismissCurrentCoodinator()

    var state: ChatCreateFlow.ViewState { get set }
    var resources: ChatCreateResourcable.Type { get }
    
    var isSnackbarPresented: Bool { get set }

    var searchText: String { get set }
    
    var snackBarText: String { get set }

    var shackBarColor: Color { get set }

    func onTapCreateCell(_ action: CreateAction)

    var lastUsersSections: [any ViewGeneratable] { get set }
    var isSearching: Bool { get set }
}

// MARK: - ChatCreateViewModel

final class ChatCreateViewModel: ObservableObject, ChatCreateViewModelProtocol {

    // MARK: - Internal Properties

    @Published var searchText = ""
    @Published var isSnackbarPresented = false
    @Published private(set) var contacts: [Contact] = []
    @Published var state: ChatCreateFlow.ViewState = .idle
    @Published var existingContacts: [Contact] = []
    @Published var waitingContacts: [Contact] = []
    @Published var snackBarText = ""
    @Published var shackBarColor: Color = .green
    var actions: [any ViewGeneratable] = []
    var lastUsersSections: [any ViewGeneratable] = []
    @Published var isSearching = false
    @Published var isTappedCreateDirectChat = false
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    var rooms: [AuraRoomData] = []
    let resources: ChatCreateResourcable.Type = ChatCreateResources.self

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let matrixUseCase: MatrixUseCaseProtocol
    private(set) var contactsUseCase = ContactsUseCase.shared
    private let config: ConfigType

    // MARK: - Lifecycle

    init(
        config: ConfigType = Configuration.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        resources: ChatCreateResourcable.Type = ChatCreateResources.self
    ) {
        self.config = config
        self.matrixUseCase = matrixUseCase
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
    
    func dismissCurrentCoodinator() {
        self.coordinator?.toParentCoordinator()
    }

    func onTapCreateCell(_ action: CreateAction) {
        vibrate()
        switch action {
        case .groupChat:
            coordinator?.selectContact()
        case .newContact:
            coordinator?.createContact()
        case .createChannel:
            coordinator?.createChannel(contacts: [])
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
					self?.state = .loading
                    self?.syncContacts()
                    self?.actions = CreateAction.allCases.map {
                        let value = CreateActionViewModel(data: $0) { result in
                            self?.onTapCreateCell(result)
                        }
                        return value
                    }
                }
            }
            .store(in: &subscriptions)
		matrixUseCase.objectChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }
            .store(in: &subscriptions)
        $searchText
            .debounce(for: 0.05, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                let group = DispatchGroup()
                if !text.isEmpty {
                    var findedContacts: [Contact] = []
                    group.enter()
                    self.matrixUseCase.searchUser(text) { name in
                        if let name = name {
                            findedContacts = [
                                .init(
                                    mxId: text,
                                    avatar: nil,
                                    name: name ,
                                    status: "", phone: "",
                                    type: .existing,
                                    onTap: { value in
                                        self.onTapUser(value)
                                    }
                                )
                            ]
                            group.leave()
                        } else {
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        var existing = self.existingContacts.filter({
                            $0.name.lowercased().contains(text.lowercased())
                            || $0.phone.removeCharacters(from: "- ()").contains(text)
                            || $0.mxId.lowercased().contains(text.lowercased()) })
                        findedContacts.forEach { value in
                            let index = self.existingContacts.firstIndex(where: { $0.mxId == value.mxId })
                            if index != nil {
                                findedContacts.remove(at: index ?? 0)
                            }
                        }
                        let waitingFilteredContacts = self.waitingContacts.filter({
                            $0.name.lowercased().contains(text.lowercased())
                            || $0.phone.removeCharacters(from: "- ()").contains(text)
                            || $0.mxId.lowercased().contains(text.lowercased()) })
                        existing = findedContacts + existing
                        self.lastUsersSections = [ChatCreateSection(data: .contacts,
                                                                    views: existing),
                                                  ChatCreateSection(data: .invite,
                                                                    views: waitingFilteredContacts)]
                        self.state = .showContent
                    }
                } else {
                    self.lastUsersSections = [ChatCreateSection(data: .contacts,
                                                                views: self.existingContacts),
                                              ChatCreateSection(data: .invite,
                                                                views: self.waitingContacts)]
                    self.objectWillChange.send()
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
        contacts = contactsUseCase.getContacts()
    }

    private func setContacts() {
        self.contactsUseCase.reuqestUserContacts { contact in
            self.contactsUseCase.matchServerContacts(
                contact, .send
            ) { [weak self] result in
                guard let self = self else { return }
                self.existingContacts = result.filter { ($0.type == .lastUsers || $0.type == .existing)
                    && $0.mxId != self.matrixUseCase.getUserId() }
                self.lastUsersSections = []
                self.waitingContacts = result.filter({ $0.type == .waitingContacts })
                let usersWithoutName = self.existingContacts.filter({ $0.mxId == $0.name })
                let group = DispatchGroup()
                if !usersWithoutName.isEmpty {
                    group.enter()
                }
                usersWithoutName.forEach { value in
                    self.matrixUseCase.searchUser(value.mxId) { result in
                        if result != nil {
                            let user = Contact(mxId: value.mxId,
                                               avatar: value.avatar,
                                               name: result ?? value.mxId,
                                               status: value.status,
                                               phone: value.phone,
                                               isAdmin: value.isAdmin,
                                               type: value.type) { contact in
                                self.onTapUser(contact)
                            }
                            if let index = self.existingContacts.firstIndex(where: { $0.mxId == value.mxId }) {
                                self.existingContacts[index] = user
                            }
                            if usersWithoutName.last == value {
                                group.leave()
                            }
                        } else {
                            if usersWithoutName.last == value {
                                group.leave()
                            }
                        }
                    }
                }
                group.notify(queue: .main) {
                    if !self.existingContacts.isEmpty {
                        self.lastUsersSections.append(
                            ChatCreateSection(
                                data: .contacts,
                                views: self.existingContacts
                            )
                        )
                    }
                    self.lastUsersSections.append(
                        ChatCreateSection(
                            data: .invite,
                            views: self.waitingContacts
                        )
                    )
                    self.state = .showContent
                }
            } onTap: { value in
                self.onTapUser(value)
            }
        }
    }

    private func syncContacts() {
        contactsUseCase.syncContacts { state in
            switch state {
            case .allowed:
                self.setContacts()
            case .notDetermined:
                self.contactsUseCase.requestContactsAccess { isAllowed in
                    if isAllowed {
                        self.setContacts()
                    } else {
                        self.state = .contactsAccessFailure
                    }
                }
            case .restricted, .denied, .unknown:
                self.state = .contactsAccessFailure
            }
        }
    }

    private func showSnackBar(text: String, color: Color) {
        snackBarText = text
        shackBarColor = color
        isSnackbarPresented = true
        delay(3) { [weak self] in
            withAnimation(.linear(duration: 0.25)) {
                self?.isSnackbarPresented = false
            }
        }
    }

    private func openRoom(_ room: AuraRoomData) {
        coordinator?.onFriendProfile(room: room)
    }

    private func onTapUser(_ contact: Contact) {
        if isTappedCreateDirectChat {
            return
        }
        isTappedCreateDirectChat = true
        if let auraRoomData: AuraRoomData = matrixUseCase.customCheckRoomExist(mxId: contact.mxId) {
            isTappedCreateDirectChat = false
            coordinator?.onFriendProfile(room: auraRoomData)
        } else {
            guard contact.type == .existing || contact.type == .lastUsers else {
                isTappedCreateDirectChat = false
                return
            }
            matrixUseCase.createDirectRoom(userId: contact.mxId) { [weak self] state, roomId in
                guard let self = self else { return }
                self.isTappedCreateDirectChat = false
                switch state {
                case .roomCreateError:
                    self.showSnackBar(
                        text: state.text,
                        color: state.color
                    )
                case .roomCreateSucces, .roomAlreadyExist:
                    self.matrixUseCase.objectChangePublisher.send()

                    if let mxRoomId = roomId,
                       let auraRoomData: AuraRoomData = matrixUseCase.auraNoEventsRooms.first(
                        where: { $0.roomId == mxRoomId }
                       ) {
                        coordinator?.onFriendProfile(room: auraRoomData)
                    } else {
                        self.dismissCurrentCoodinator()
                    }
                }
            }
        }
    }
}
