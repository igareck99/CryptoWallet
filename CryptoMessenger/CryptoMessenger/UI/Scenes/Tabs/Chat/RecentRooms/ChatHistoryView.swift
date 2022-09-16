import Combine
import SwiftUI

// swiftlint: disable all
protocol ChatHistoryViewDelegate: ObservableObject {

    var rooms: [AuraRoom] { get }

    var groupAction: GroupAction? { get set }
    var translateAction: TranslateAction? { get set }

    var sources: ChatHistorySourcesable.Type { get }

    var eventSubject: PassthroughSubject<ChatHistoryFlow.Event, Never> { get }

    func rooms(with filter: String) -> [AuraRoom]

    func markAllAsRead()

}

// MARK: - ChatHistoryView

struct ChatHistoryView<ViewModel>: View where ViewModel: ChatHistoryViewDelegate {

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @State private var searchText = ""
    @State private var searching = false
    @State private var createRoomSelected = false
    @State private var chatData = ChatData()
    @State private var selectedImage: UIImage?
    @State private var selectedRoomId: ObjectIdentifier?

    @State private var actionSheet: IOActionSheet?

    private var searchResults: [AuraRoom] {
        viewModel.rooms(with: searchText)
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                if actionSheet == nil {
                    actionSheet = IOActionSheet(title: nil,
                                                font: UIFont.systemFont(ofSize: 16),
                                                color:UIColor(.black))
                    actionSheet?.addButton(
                        title: viewModel.sources.readAll,
                        action: {
                            viewModel.markAllAsRead()
                        })
                    actionSheet?.cancelButtonTitle = viewModel.sources.decline
                    actionSheet?.cancelButtonTextColor = .red
                    actionSheet?.backgroundColor = .white
                    viewModel.eventSubject.send(.onAppear)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        viewModel.sources.chatLogo
                        Text("0.50 \(viewModel.sources.AUR)")
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
                            viewModel.sources.chatWriteMessage
                        }
                        Button(action: {
                            actionSheet?.show()
                        }, label: {
                            viewModel.sources.chatSettings
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
    
    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar(
                    placeholder: viewModel.sources.searchPlaceholder,
                    searchText: $searchText,
                    searching: $searching
                )
                if searching {
                    Spacer()
                    Button(viewModel.sources.decline) {
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
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.eventSubject.send(.onDeleteRoom(room.room.roomId))
                            } label: {
                                viewModel.sources.chatReactionDelete
                                    .renderingMode(.original)
                                    .foreground(.blue())
                            }
                            .tint(.gray.opacity(0.1))
                        }
                        .onTapGesture {
                            viewModel.eventSubject.send(.onShowRoom(room))
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}
