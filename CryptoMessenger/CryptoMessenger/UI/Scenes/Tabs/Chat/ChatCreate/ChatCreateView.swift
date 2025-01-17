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
    @State var showContactCreate = false
    @State var showChannelCreate = false

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
                        destination: SelectContactView(viewModel: SelectContactViewModel(mode: .groupCreate),
                                                       chatData: $chatData,
                                                       groupCreated: $groupCreated),
                        isActive: $showContacts
                    )
                )
                .overlay(
                    EmptyNavigationLink(
                        destination: CreateContactView(viewModel: CreateContactViewModel(),
                                                       showContactCreate: $showContactCreate),
                        isActive: $showContactCreate
                    )
                )
                .overlay(
                    EmptyNavigationLink(
                        destination: CreateChannelAssemby.make {
                            presentationMode.wrappedValue.dismiss()
                        },
                        isActive: $showChannelCreate
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
                    if !viewModel.waitingContacts.isEmpty && viewModel.state == .showContent {
                        ForEach(CreateAction.allCases) { action in
                            VStack(spacing: 0) {
                                actionView(action)
                                    .padding([.leading, .trailing], 16)
                                    .onTapGesture {
                                        vibrate()
                                        switch action {
                                        case .groupChat:
                                            showContacts.toggle()
                                        case .newContact:
                                            showContactCreate.toggle()
                                        case .createChannel:
                                            showChannelCreate.toggle()
                                        default:
                                            break
                                        }
                                    }
                            }
                        }
                    }

					if viewModel.state == .loading {
                        ProgressView()
                            .tint(Color(.blue()))
                            .padding(.top, 34)
                    }

					if viewModel.state == .contactsAccessFailure {
						Text("Не удалось получить доступ к контактам. Вы можете предоставить доступ к контактам в настройках")
							.multilineTextAlignment(.center)
							.font(.regular(15))
							.foreground(.black())
							.padding(.init(top: 8, leading: 16, bottom: 16, trailing: 16))
						Button(action: {
							UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
						}, label: {
							Text("Открыть настройки")
								.frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
								.font(.regular(15))
								.overlay(
									RoundedRectangle(cornerRadius: 8)
										.stroke(.blue, lineWidth: 1)
								)
						})
							.frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
							.background(.white())
							.padding(.horizontal, 16)
					}

                    let contacts = viewModel.searchText.isEmpty ?
                                   viewModel.existingContacts : viewModel.filteredContacts
                    if !contacts.isEmpty && viewModel.state == .showContent {
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
                    let waitContacts = viewModel.searchText.isEmpty ?
                                    viewModel.waitingContacts : viewModel.waitingFilteredContacts
                    if !waitContacts.isEmpty && viewModel.state == .showContent {
                        sectionView(R.string.localizable.createActionInviteSection())
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(waitContacts) { contact in
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
                    .font(.system(size: 17))
                    .foreground(.black())
                    .frame(height: 57)

                Spacer()
            }

            if action != .groupChat {
                Rectangle()
                    .fill(Color(.gray(0.8)))
                    .frame(height: 1)
                    .padding(.leading, 37)
                    .padding(.trailing, 0)
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
