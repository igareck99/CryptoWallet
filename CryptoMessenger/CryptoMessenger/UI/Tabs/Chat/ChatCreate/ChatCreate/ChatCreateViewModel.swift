import Combine
import Foundation
import SwiftUI

protocol ChatCreateViewModelProtocol: ObservableObject {
    var actions: [any ViewGeneratable] { get set }

    func send(_ event: ChatCreateFlow.Event)

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
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    let resources: ChatCreateResourcable.Type = ChatCreateResources.self

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ChatCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private(set) var contactsUseCase = ContactsUseCase.shared
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

    func onTapCreateCell(_ action: CreateAction) {
        vibrate()
        switch action {
        case .groupChat:
            coordinator?.selectContact()
        case .newContact:
            coordinator?.createContact()
        case .createChannel:
            coordinator?.createChannel()
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
            .sink { _ in }
            .store(in: &subscriptions)
        $searchText
            .debounce(for: 0.05, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                let group = DispatchGroup()
                var firstSection: [Contact] = []
                var secondSection: [Contact] = []
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
            self.waitingContacts = contact.map {
                return Contact(mxId: "",
                               avatar: nil,
                               name: $0.firstName + "  " + $0.lastName,
                               status: "",
                               phone: $0.phoneNumber,
                               isAdmin: false, type: .waitingContacts) { _ in
                    
                }
            }.sorted { $1.name > $0.name }
            self.contactsUseCase.matchServerContacts(contact,
                                                     .groupCreate) { result in
                                                         self.existingContacts = result.filter { $0.type == .lastUsers || $0.type == .existing }
                                                         self.lastUsersSections = []
                                                         if !self.existingContacts.isEmpty {
                                                             self.lastUsersSections.append(ChatCreateSection(data: .contacts,
                                                                                                             views: self.existingContacts))
                                                         }
                                                         self.lastUsersSections.append(ChatCreateSection(data: .invite,
                                                                                                         views: self.waitingContacts))
                                                         self.state = .showContent
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
    
    private func showSnackBar(_ text: String,
                              _ color: Color) {
        snackBarText = text
        shackBarColor = color
        isSnackbarPresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            withAnimation(.linear(duration: 0.25)) {
                self?.isSnackbarPresented = false
            }
        }
    }

    private func onTapUser(_ contact: Contact) {
        switch contact.type {
        case .lastUsers, .existing:
            matrixUseCase.createDirectRoom([contact.mxId]) { result in
                switch result {
                case .roomAlreadyExist, .roomCreateError:
                    self.showSnackBar(result.rawValue,
                                      result.color)
                case .roomCreateSucces:
                    self.coordinator?.toParentCoordinator()
                }
            }
        default:
            break
        }
    }
}
