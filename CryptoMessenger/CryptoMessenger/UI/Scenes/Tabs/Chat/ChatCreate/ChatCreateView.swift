import SwiftUI

// MARK: - CreateAction

enum CreateAction: CaseIterable, Identifiable {

    // MARK: - Types

    case createChannel
    case newContact
    case groupChat

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var text: Text {
        switch self {
        case .createChannel:
            return Text("Создать канал")
        case .newContact:
            return Text("Новый контакт")
        case .groupChat:
            return Text("Групповой чат")
        }
    }

    var color: Palette {
        switch self {
        default:
            return .black()
        }
    }

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

    @StateObject var viewModel: ChatCreateViewModel
    var onCreateGroup: VoidBlock?

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
                .onReceive(viewModel.$closeScreen) { closed in
                    if closed {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }, label: {
//                            R.image.navigation.backButton.image
//                        })
//                    }
//
//                    ToolbarItem(placement: .principal) {
//                        Text("Чаты")
//                            .font(.bold(15))
//                            .foreground(.black())
//                    }
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//
//                        }, label: {
//                            R.image.chat.group.search.image
//                        })
//                    }
//                }
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar(
                    placeholder: "Поиск по идентификатору",
                    searchText: $viewModel.searchText,
                    searching: $viewModel.searching
                )
                if viewModel.searching {
                    Spacer()
                    Button("Отменить") {
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
            .padding(.top, 16)
            .padding([.leading, .trailing, .bottom], 16)

            ScrollView(.vertical, showsIndicators: false) {
                Rectangle()
                    .fill(Color(.gray(0.8)))
                    .frame(height: 1)

                VStack(spacing: 0) {
                    ForEach(CreateAction.allCases.filter({ $0 == .groupChat })) { action in
                        VStack(spacing: 0) {
                            actionView(action)
                                .padding([.leading, .trailing], 16)
                                .onTapGesture {
                                    vibrate()
                                    delay(0.1) { onCreateGroup?() }
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }

                    if !viewModel.contacts.isEmpty {
                        sectionView("Контакты")

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.contacts) { contact in
                                ContactRow(
                                    avatar: contact.avatar,
                                    name: contact.name,
                                    status: contact.status.isEmpty ? "Привет, теперь я в Aura" : contact.status,
                                    hideSeparator: viewModel.contacts.last?.id == contact.id
                                ).onTapGesture {
                                    vibrate()
                                    viewModel.send(.onCreate([contact.mxId]))
                                }
                            }
                        }
                    }

                    sectionView("Пригласить в Aura")

                    ContactRow(
                        avatar: nil,
                        name: "Karen Castillo",
                        status: "+7(925)813-31-62",
                        showInviteButton: true
                    ).opacity(0.6)

                    ContactRow(
                        avatar: nil,
                        name: "Karen Castillo",
                        status: "+7(925)813-31-62",
                        showInviteButton: true
                    ).opacity(0.6)

                    ContactRow(
                        avatar: nil,
                        name: "Karen Castillo",
                        status: "+7(925)813-31-62",
                        showInviteButton: true
                    ).opacity(0.6)
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

            Text("Показать больше")
                .font(.medium(13))
                .foreground(.black())
                .padding(.trailing, 16)
                .frame(height: 24)
        }
        .background(.paleBlue())
    }
}
