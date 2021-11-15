import SwiftUI

// MARK: - ChatHistoryView

struct ChatHistoryView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatHistoryViewModel
    var onRoomTap: GenericBlock<AuraRoom>?

    // MARK: - Private Properties

    @State private var searchText = ""
    @State private var searching = false
    private var searchResults: [AuraRoom] {
        searchText.isEmpty ? viewModel.rooms : viewModel.rooms.filter {
            $0.summary.displayname.lowercased().contains(searchText.lowercased())
            || $0.summary.topic?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }

    // MARK: - Body

    var body: some View {
        content
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
    }

    // MARK: - Body Properties

    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar(searchText: $searchText, searching: $searching)
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
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            vibrate()
                            onRoomTap?(room)
                        }
//                        .overlay(
//                            NavigationLink(destination: {
//                                ChatRoomView(viewModel: .init(room: room))
//                            }, label: {
//                                EmptyView()
//                            }).opacity(0)
//                        )
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        UIApplication.shared.dismissKeyboard()
                    }
            )
        }
    }
}

// MARK: - SearchBar

struct SearchBar: View {

    // MARK: - Internal Properties

    @Binding var searchText: String
    @Binding var searching: Bool

    // MARK: - Body

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(.paleBlue()))
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                TextField("Поиск по чатам и каналам", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 36)
        .cornerRadius(8)
    }
}

// MARK: - UIApplication ()

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
