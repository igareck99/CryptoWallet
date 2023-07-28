import SwiftUI

// MARK: - ChatCreateView

struct ChatCreateView: View {

    // MARK: - Internal Properties

    @Binding var chatData: ChatData
    @StateObject var viewModel: ChatCreateViewModel
    @State private var showSearchBar = false

    // MARK: - Private Properties

    @State private var showContacts = false
    @State private var groupCreated = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
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
    }

    private var content: some View {
        VStack(spacing: 0) {
            if showSearchBar {
                HStack(spacing: 0) {
                    SearchBar(
                        placeholder: viewModel.resources.createActionSearch,
                        searchText: $viewModel.searchText,
                        searching: $viewModel.searching
                    )
                    if viewModel.searching {
                        Spacer()
                        Button(viewModel.resources.createActionCancel) {
                            viewModel.searchText = ""
                            withAnimation {
                                withAnimation(.linear(duration: 0.25)) {
                                    viewModel.searching = false
                                    showSearchBar = false
                                    UIApplication.shared.dismissKeyboard()
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(viewModel.resources.buttonBackground)
                    }
                }
                .padding([.horizontal, .vertical], 16)
            } else {
                headerView
                    .padding(.top, 15)
            }

            ScrollView(.vertical, showsIndicators: false) {
                Rectangle()
                    .fill(viewModel.resources.rectangleBackground)
                    .frame(height: 1)

                VStack(spacing: 0) {
                    if !viewModel.waitingContacts.isEmpty && viewModel.state == .showContent {
                        ForEach(CreateAction.allCases) { action in
                            VStack(spacing: 0) {
                                actionView(action)
                                    .listRowSeparator(.hidden)
                                    .padding([.leading, .trailing], 16)
                                    .onTapGesture {
                                        vibrate()
                                        switch action {
                                        case .groupChat:
                                            guard let c = viewModel.coordinator else { return }
                                            viewModel.coordinator?.selectContact($chatData, c)
                                        case .newContact:
                                            if let coordinator = viewModel.coordinator {
                                                viewModel.coordinator?.createContact(coordinator)
                                            }
                                        case .createChannel:
                                            if let coordinator = viewModel.coordinator {
                                                viewModel.coordinator?.createChannel(coordinator)
                                            }
                                        }
                                    }
                            }
                        }
                    }

					if viewModel.state == .loading {
                        ProgressView()
                            .tint(viewModel.resources.buttonBackground)
                            .padding(.top, 34)
                    }

					if viewModel.state == .contactsAccessFailure {
                        Text(viewModel.resources.chatContactEror)
							.multilineTextAlignment(.center)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(viewModel.resources.titleColor)
							.padding(.init(top: 8, leading: 16, bottom: 16, trailing: 16))
						Button(action: {
							UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
						}, label: {
                            Text(viewModel.resources.chatSettings)
								.frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                                .font(.system(size: 15, weight: .regular))
								.overlay(
									RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.resources.buttonBackground, lineWidth: 1)
								)
						})
							.frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                            .background(viewModel.resources.background)
							.padding(.horizontal, 16)
					}

                    let contacts = viewModel.searchText.isEmpty ?
                                   viewModel.existingContacts : viewModel.filteredContacts
                    if !contacts.isEmpty && viewModel.state == .showContent {
                        sectionView(viewModel.resources.createActionContactsSection)
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(contacts) { contact in
                                ContactRow(
                                    avatar: contact.avatar,
                                    name: contact.name,
                                    status: contact.status.isEmpty ? viewModel.resources.chatWelcome : contact.status,
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
                        sectionView(viewModel.resources.createActionInviteSection)
                            .padding(.top, 24)
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
                    .foregroundColor(viewModel.resources.titleColor)
                    .frame(height: 57)

                Spacer()
            }

            
            Rectangle()
                .fill(viewModel.resources.rectangleBackground)
                .frame(height: 0.8)
                .padding(.leading, 37)
                .padding(.trailing, 16)
        }
    }
    
    private var headerView: some View {
        HStack {
            viewModel.resources.fatarrowImage
                .padding(.leading, 9)
                .frame(width: 12, height: 21)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("Чаты")
                .font(.system(size: 17, weight: .semibold))
            Spacer()
            viewModel.resources.fatloopImage
                .frame(width: 17, height: 17)
                .padding(13)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.25)) {
                        showSearchBar.toggle()
                    }
                }
        }
    }

    private func sectionView(_ title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(viewModel.resources.titleColor)
                .padding(.leading, 16)
                .frame(height: 24)

            Spacer()
        }
        .background(viewModel.resources.sectionBackground)
    }
}
