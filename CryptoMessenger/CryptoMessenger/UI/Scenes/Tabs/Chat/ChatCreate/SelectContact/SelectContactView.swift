import Combine
import Foundation
import SwiftUI

// MARK: - SelectContactView

struct SelectContactView: View {

    // MARK: - Private Properties

    @State private var pickedContacts: [Contact] = []
    @Binding var chatData: ChatData
    @Binding private var groupCreated: Bool
    @StateObject private var viewModel: SelectContactViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State private var showChatGroup = false
    let contactsLimit: Int?
    var onSelectContact: GenericBlock<[Contact]>?

    // MARK: - Life Cycle

    init(
        viewModel: SelectContactViewModel,
        chatData: Binding<ChatData> = .constant(.init()),
        groupCreated: Binding<Bool> = .constant(false),
        contactsLimit: Int? = nil,
        onSelectContact: GenericBlock<[Contact]>? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._chatData = chatData
        self._groupCreated = groupCreated
        self.contactsLimit = contactsLimit
        self.onSelectContact = onSelectContact
    }

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
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
                    Text(contactsLimit == nil ? "Групповой чат" : "Выберите контакт")
                        .font(.bold(15))
                        .foreground(.black())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        switch viewModel.mode {
                        case .send, .groupCreate:
                            if contactsLimit != nil {
                                onSelectContact?(pickedContacts)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                chatData.contacts = pickedContacts
                                showChatGroup.toggle()
                            }
                        case .add, .admins:
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(pickedContacts.isEmpty ? .darkGray() : .blue())
                    })
                        .disabled(pickedContacts.isEmpty)
                }
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ZStack {
            Color(.white()).ignoresSafeArea()

            if viewModel.existingContacts.isEmpty {
                ProgressView()
                    .tint(Color(.blue()))
            }

            ScrollView(.vertical, showsIndicators: false) {
                let groupedContacts = Dictionary(grouping: viewModel.existingContacts) {
                    $0.name.firstLetter.uppercased()
                }
                ForEach(groupedContacts.keys.sorted(), id: \.self) { key in
                    sectionView(key)
                    let contacts = groupedContacts[key] ?? []
                    ForEach(0..<contacts.count) { index in
                        let contact = contacts[index]
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                if pickedContacts.contains(where: { $0.id == contact.id }) {
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
										if pickedContacts.contains(where: { $0.id == contact.id }) {
											pickedContacts.removeAll { $0.id == contact.id }
										} else {
											pickedContacts.append(contact)
										}
                                    }
                            }
                            .padding(.leading, 16)
                        }
                    }
                }
            }.opacity(viewModel.existingContacts.isEmpty ? 0 : 1)
        }
		.padding(.top, 1)
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
