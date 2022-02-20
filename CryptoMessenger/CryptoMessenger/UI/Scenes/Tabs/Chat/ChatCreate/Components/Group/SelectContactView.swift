import Combine
import Foundation
import MatrixSDK
import SwiftUI

// MARK: - SelectContactView

struct SelectContactView: View {

    // MARK: - Mode

    enum Mode: Identifiable {

        // MARK: - Types

        case select, add

        // MARK: - Internal Properties

        var id: UUID { UUID() }
    }

    // MARK: - Private Properties

    private let mode: Mode
    @Binding private var chatData: ChatData
    @Binding private var groupCreated: Bool
    @StateObject private var viewModel = SelectContactViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State private var showChatGroup = false

    // MARK: - Life Cycle

    init(mode: Mode = .select, chatData: Binding<ChatData>, groupCreated: Binding<Bool> = .constant(false)) {
        self.mode = mode
        self._chatData = chatData
        self._groupCreated = groupCreated
    }

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .overlay(
                EmptyNavigationLink(
                    destination: ChatGroupView(chatData: $chatData, groupCreated: $groupCreated),
                    isActive: $showChatGroup
                )
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        R.image.navigation.backButton.image
                    })
                }

                ToolbarItem(placement: .principal) {
                    Text("Групповой чат")
                        .font(.bold(15))
                        .foreground(.black())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        switch mode {
                        case .select:
                            showChatGroup.toggle()
                        case .add:
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(chatData.contacts.isEmpty ? .darkGray() : .blue())
                    })
                        .disabled(chatData.contacts.isEmpty)
                }
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ZStack {
            Color(.white()).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                let groupedContacts = Dictionary(grouping: viewModel.existingContacts) { $0.name.firstLetter.uppercased() }
                ForEach(groupedContacts.keys.sorted(), id: \.self) { key in
                    sectionView(key)
                    let contacts = groupedContacts[key] ?? []
                    ForEach(0..<contacts.count) { index in
                        let contact = contacts[index]
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                if chatData.contacts.contains(where: { $0.id == contact.id }) {
                                    R.image.chat.group.check.image
                                        .transition(.scale.animation(.linear(duration: 0.2)))
                                } else {
                                    R.image.chat.group.uncheck.image
                                                .transition(.opacity.animation(.linear(duration: 0.2)))
                                }

                                ContactRow(
                                    avatar: contact.avatar,
                                    name: contact.name,
                                    status: contact.status,
                                    hideSeparator: contact.id == contacts.last?.id
                                )
                                    .background(.white())
                                    .id(contact.id)
                                    .onTapGesture {
                                        vibrate()
                                        if chatData.contacts.contains(where: { $0.id == contact.id }) {
                                            chatData.contacts.removeAll { $0.id == contact.id }
                                        } else {
                                            chatData.contacts.append(contact)
                                        }
                                    }
                            }
                            .padding(.leading, 16)
                        }
                    }
                }
            }
        }
    }

    private func sectionView(_ title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.medium(15))
                .foreground(.black())
                .padding(.leading, 16)
                .frame(height: 24)

            Spacer()
        }
        .background(.paleBlue())
    }
}

// MARK: - SelectContactViewModel

final class SelectContactViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published private(set) var closeScreen = false
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var state: SelectContactFlow.ViewState = .idle
    @Published private(set) var existingContacts: [Contact] = []
    @Published private(set) var waitingContacts: [Contact] = []

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SelectContactFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SelectContactFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var contactsStore: ContactsManager
    @Injectable private var apiClient: APIClientManager

    // MARK: - Lifecycle

    init() {
        bindInput()
        bindOutput()
        getContacts(mxStore.allUsers())
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

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in

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
                let homeServer = Bundle.main.object(for: .matrixURL).asURL()
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

                let mxUsers: [MXUser] = self?.mxStore.allUsers() ?? []
                let lastUsers: [Contact] = mxUsers
                    .filter { $0.userId != self?.mxStore.getUserId() }
                    .map {
                        var contact = Contact(
                            mxId: $0.userId ?? "",
                            avatar: nil,
                            name: $0.displayname ?? "",
                            status: $0.statusMsg ?? "Привет, теперь я в Aura"
                        )
                        if let avatar = $0.avatarUrl {
                            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
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
                            status: "Привет, теперь я в Aura"
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

// MARK: - SelectContactFlow

enum SelectContactFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(APIError)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onNextScene
    }
}
