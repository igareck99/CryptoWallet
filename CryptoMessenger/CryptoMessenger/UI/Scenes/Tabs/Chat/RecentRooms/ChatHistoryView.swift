import SwiftUI

// MARK: - ChatHistoryView

struct ChatHistoryView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatHistoryViewModel

    // MARK: - Private Properties

    @State private var searchText = ""
    @State private var searching = false
    @State private var createRoomSelected = false
    @State private var chatData = ChatData()
    @State private var selectedImage: UIImage?
    @State private var selectedRoomId: ObjectIdentifier?
    @State private var cardGroupPosition: CardPosition = .bottom
    @State private var actionSheet = IOActionSheet(title: nil,
                                                   font: UIFont.systemFont(ofSize: 16),
                                                   color: UIColor(.black))

    private var searchResults: [AuraRoom] {
        searchText.isEmpty ? viewModel.rooms : viewModel.rooms.filter {
            $0.summary.displayname.lowercased().contains(searchText.lowercased())
            || $0.summary.topic?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }

    // MARK: - Body
    func readAll() {
        for room in viewModel.rooms {
            room.markAllAsRead()
        }
    }

    var body: some View {
        content
            .onAppear {
                actionSheet.addButton(title: "Прочитать все",
                                      action: {
                    for room in viewModel.rooms {
                        room.markAllAsRead()
                    }
                })
                actionSheet.cancelButtonTitle = "Отмена"
                actionSheet.cancelButtonTextColor = .red
                actionSheet.backgroundColor = .white
                viewModel.send(.onAppear)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        R.image.chat.logo.image
                        Text("0.50 AUR")
                                .font(.regular(15))
                                .foreground(.black())
                        Spacer()
                    }
                    groupMenuView
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 0) {
                        Button {
                            createRoomSelected.toggle()
                        } label: {
                            R.image.chat.writeMessage.image
                        }

                        Button(action: {
                            actionSheet.show()
                            
                        }, label: {
                            R.image.chat.settings.image
                        })

                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $createRoomSelected) {
                ChatCreateView(chatData: $chatData, viewModel: .init())
            }
    }

    // MARK: - Body Properties

    private var groupMenuView: some View {
        ZStack {
            Color(cardGroupPosition == .bottom ? .clear : .black(0.4))
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardGroupPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardGroupPosition = .bottom
                }

            SlideCard(position: $cardGroupPosition) {
                VStack(spacing: 0) {
                    GroupMenuView(action: $viewModel.groupAction, cardPosition: $cardGroupPosition)
                }.padding(.vertical, 16)
            }
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar(
                    placeholder: "Поиск по чатам и каналам",
                    searchText: $searchText,
                    searching: $searching
                )
                if searching {
                    Spacer()
                    Button("Отменить") {
                        searchText = ""
                        withAnimation {
                            searching = false
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                    .buttonStyle(.plain)
                    .foreground(.blue())
                }
            }
            .padding([.leading, .trailing, .bottom], 16)

            List {
                ForEach(searchResults) { room in
                    ChatHistoryRow(room: room)
                        .background(.white())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
//                        .overlay(
//                            NavigationLink(destination: {
//                                ChatRoomView(viewModel: .init(room: room))
//                            }, label: {
//                                EmptyView()
//                            }).opacity(0)
//                        )
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.send(.onDeleteRoom(room.room.roomId))
                            } label: {
                                R.image.chat.reaction.delete.image
                                    .renderingMode(.original)
                                    .foreground(.blue())
                            }
                            .tint(.gray.opacity(0.1))
                        }
                        .onTapGesture {
                            viewModel.send(.onShowRoom(room))
                        }
                    
//                    quickMenuView
                }
            }
            .listStyle(.plain)
        }
    }
}
