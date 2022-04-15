import SwiftUI

// MARK: - CreateAction

enum CreateAction: CaseIterable, Identifiable {

    // MARK: - Types

    case createChannel, newContact, groupChat

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var text: Text {
        switch self {
        case .createChannel:
            return Text(R.string.localizable.createActionCreateChannel())
        case .newContact:
            return Text(R.string.localizable.createActionNewContact())
        case .groupChat:
            return Text(R.string.localizable.createActionGroupChat())
        }
    }

    var color: Palette { .black() }

    var image: Image {
        switch self {
        case .createChannel:
            return R.image.chat.group.channel.image
        case .newContact:
            return R.image.chat.group.contact.image
        case .groupChat:
            return R.image.chat.group.group.image
        }
    }
}

// MARK: - ChatCreateView

struct ChatCreateView: View {

    // MARK: - Internal Properties

    @Binding var chatData: ChatData
    @StateObject var viewModel: ChatCreateViewModel

    // MARK: - Private Properties

    @State private var showContacts = false
    @State private var groupCreated = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
                .onReceive(viewModel.$closeScreen) { closed in
                    if closed {
                        chatData = .init()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .onChange(of: groupCreated) { created in
                    if created {
                        viewModel.send(.onCreateGroup(chatData))
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.send(.onAppear)
                }
                .overlay(
                    EmptyNavigationLink(
                        destination: SelectContactView(chatData: $chatData, groupCreated: $groupCreated),
                        isActive: $showContacts
                    )
                )
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar(
                    placeholder: R.string.localizable.createActionSearch(),
                    searchText: $viewModel.searchText,
                    searching: $viewModel.searching
                )
                if viewModel.searching {
                    Spacer()
                    Button(R.string.localizable.createActionCancel()) {
                        viewModel.searchText = ""
                        withAnimation {
                            viewModel.searching = false
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                    .buttonStyle(.plain)
                    .foreground(.blue())
                }
            }
            .padding([.horizontal, .vertical], 16)

            ScrollView(.vertical, showsIndicators: false) {
                Rectangle()
                    .fill(Color(.gray(0.8)))
                    .frame(height: 1)

                VStack(spacing: 0) {
                    if !viewModel.waitingContacts.isEmpty {
                        ForEach(CreateAction.allCases.filter({ $0 == .groupChat })) { action in
                            VStack(spacing: 0) {
                                actionView(action)
                                    .padding([.leading, .trailing], 16)
                                    .onTapGesture {
                                        vibrate()
                                        showContacts.toggle()
                                    }
                            }
                        }
                    }

                    if viewModel.waitingContacts.isEmpty {
                        ProgressView()
                            .tint(Color(.blue()))
                            .padding(.top, 34)
                    }

                    let contacts = viewModel.filteredContacts.isEmpty ? viewModel.existingContacts : viewModel.filteredContacts

                    if !contacts.isEmpty {
                        sectionView(R.string.localizable.createActionContactsSection())

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(contacts) { contact in
                                ContactRow(
                                    avatar: contact.avatar,
                                    name: contact.name,
                                    status: contact.status.isEmpty ? "Привет, теперь я в Aura" : contact.status,
                                    hideSeparator: contacts.last?.id == contact.id
                                ).onTapGesture {
                                    vibrate()
                                    viewModel.send(.onCreateDirect([contact.mxId]))
                                }
                            }
                        }
                    }

                    if !viewModel.waitingContacts.isEmpty {
                        sectionView(R.string.localizable.createActionInviteSection())

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.waitingContacts) { contact in
                                ContactRow(
                                    avatar: nil,
                                    name: contact.name,
                                    status: contact.phone,
                                    showInviteButton: true
                                ).opacity(0.6)
                            }
                        }
                    }
                }
            }
        }
    }

    private func actionView(_ action: CreateAction) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                action.image

                action.text
                    .font(.semibold(15))
                    .foreground(.black())
                    .frame(height: 65)

                Spacer()
            }

            if action != .groupChat {
                Rectangle()
                    .fill(Color(.gray(0.8)))
                    .frame(height: 1)
                    .padding(.leading, 52)
                    .padding(.trailing, 8)
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

            Text(R.string.localizable.createActionShowMore())
                .font(.medium(13))
                .foreground(.black())
                .padding(.trailing, 16)
                .frame(height: 24)
        }
        .background(.paleBlue())
    }
}
