import Combine
import Foundation
import SwiftUI

protocol ChatCreateViewModelProtocol: ObservableObject {
    var actions: [any ViewGeneratable] { get set }
    func send(_ event: ChatCreateFlow.Event)
    var state: ChatCreateFlow.ViewState { get set }
    var resources: ChatCreateResourcable.Type { get }
    var searchText: String { get set }
    func onTapCreateCell(_ action: CreateAction)
    var lastUsersSections: [any ViewGeneratable] { get set }
    var isSearching: Bool { get set }
}

// MARK: - ChatCreateViewModel

final class ChatCreateViewModel: ObservableObject, ChatCreateViewModelProtocol {

    // MARK: - Internal Properties

    @Published var searchText = ""
    @Published private(set) var contacts: [Contact] = []
    @Published var state: ChatCreateFlow.ViewState = .idle
    @Published var existingContacts: [Contact] = []
    @Published var waitingContacts: [Contact] = []
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
                case let .onCreateDirect(ids):
                    self?.matrixUseCase.createDirectRoom(ids,
                                                         completion: { result in
                        switch result {
                        case .roomCreateError:
                            break
                        case .roomCreateSucces:
                            self?.coordinator?.toParentCoordinator()
                        }
                    })
                case let .onCreateGroup(info):
                    self?.matrixUseCase.createGroupRoom(info, completion: { result in
                        switch result {
                        case .roomCreateError:
                            break
                        case .roomCreateSucces:
                            self?.coordinator?.toParentCoordinator()
                        }
                    })
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
                guard let self = self else { return }
                let group = DispatchGroup()
                var firstSection: [Contact] = []
                var secondSection: [Contact] = []
                if !text.isEmpty {
                    var findedContacts: [Contact] = []
                    group.enter()
                    self.matrixUseCase.searchUser(text) { name in
                        findedContacts = [
                            .init(
                                mxId: text,
                                avatar: nil,
                                name: name ?? "",
                                status: "",
                                type: .existing,
                                onTap: { value in
                                    self.onTapUser(value)
                                }
                            )
                        ]
                        group.leave()
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

    private func syncContacts() {
        contactsUseCase.syncContacts { state in
            switch state {
            case .allowed:
                self.contactsUseCase.reuqestUserContacts { contact in
                    self.contactsUseCase.matchServerContacts(contact,
                                                             .send) { result in
                                                                 self.existingContacts = result.filter { $0.type == .lastUsers }
                                                                 self.waitingContacts = result.filter { $0.type == .waitingContacts }
                                                                 self.lastUsersSections = []
                                                                 self.lastUsersSections.append(ChatCreateSection(data: .contacts,
                                                                                                                 views: self.existingContacts))
                                                                 self.lastUsersSections.append(ChatCreateSection(data: .invite,
                                                                                                                 views: self.waitingContacts))
                                                                 self.state = .showContent
                                                             } onTap: { value in
                                                                 self.onTapUser(value)
                                                             }
                }
                return
            case .notDetermined:
                self.contactsUseCase.requestContactsAccess { isAllowed in
                    if isAllowed {
                        self.contactsUseCase.reuqestUserContacts { contact in
                            self.contactsUseCase.matchServerContacts(contact,
                                                                     .send) { result in
                                                                         self.existingContacts = result.filter { $0.type == .lastUsers }
                                                                         self.waitingContacts = result.filter { $0.type == .waitingContacts }
                                                                         self.lastUsersSections = []
                                                                         self.lastUsersSections.append(ChatCreateSection(data: .contacts,
                                                                                                                         views:
                                                                                                                            self.existingContacts))
                                                                         self.lastUsersSections.append(ChatCreateSection(data: .invite,
                                                                                                                         views: self.waitingContacts))
                                                                         self.state = .showContent
                                                                     } onTap: { value in
                                                                         self.onTapUser(value)
                                                                     }
                        }
                    }
                }
                return
            case .restricted, .denied, .unknown:
                self.state = .contactsAccessFailure
            }
        }
    }

    private func onTapUser(_ contact: Contact) {
        switch contact.type {
            case .lastUsers:
            matrixUseCase.createDirectRoom([contact.mxId]) { result in
                switch result {
                case .roomCreateError:
                    break
                case .roomCreateSucces:
                    self.coordinator?.toParentCoordinator()
                }
            }
        default:
            break
        }
    }
}
