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

    private var searchResults: [AuraRoom] {
        searchText.isEmpty ? viewModel.rooms : viewModel.rooms.filter {
            $0.summary.displayname.lowercased().contains(searchText.lowercased())
            || $0.summary.topic?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
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
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 0) {
                        Button {
                            createRoomSelected.toggle()
                        } label: {
                            R.image.chat.writeMessage.image
                        }

                        Button {

                        } label: {
                            R.image.chat.settings.image
                        }

                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $createRoomSelected) {
                ChatCreateView(chatData: $chatData, viewModel: .init())
            }
    }

    // MARK: - Body Properties

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
                }
            }
            .listStyle(.plain)
        }
    }
}
