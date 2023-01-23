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
    
    func fromCurrentSender(room: AuraRoom) -> Bool

}

// MARK: - ChatHistoryView

struct ChatHistoryView<ViewModel>: View where ViewModel: ChatHistoryViewDelegate {

    // MARK: - Internal Properties

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
				showTabBar()
			}
            .onDisappear {
                showTabBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
				toolbarItems()
			}
			.sheet(isPresented: $createRoomSelected) {
				ChatCreateView(chatData: $chatData, viewModel: .init())
			}
	}

	// MARK: - Body Properties

	private var content: some View {

		let searchTextBinding = Binding(
			get: { self.searchText },
			set: {
				if self.searching {
					self.searchText = $0
				}
			}
		)

		return VStack(spacing: 0) {
			HStack(spacing: 0) {
				SearchBar(
					placeholder: viewModel.sources.searchPlaceholder,
					searchText: searchTextBinding,
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
			.padding([.leading, .trailing], 16)
			.padding(.bottom, 11)
			.padding(.top, 8)

			Divider()

			List {
				ForEach(searchResults) { room in
					VStack(spacing: 0) {
						ChatHistoryRow(room: room,
                                       isFromCurrentUser: viewModel.fromCurrentSender(room: room))
							.background(.white())
							.swipeActions(edge: .trailing) {
								Button {
									viewModel.eventSubject.send(.onDeleteRoom(room.room.roomId))
								} label: {
									viewModel.sources.chatReactionDelete
										.renderingMode(.original)
										.foreground(.blue())
								}.tint(.gray.opacity(0.1))
							}.onTapGesture {
								viewModel.eventSubject.send(.onShowRoom(room))
							}.frame(width: nil, height: 76)
						Divider()
							.foregroundColor(Color(.init(216, 216, 217)))
							.frame(height: 0.5)
							.padding(.leading, 88)
					}
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
				}
			}.listStyle(.plain)
		}
	}
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 8) {
                viewModel.sources.chatLogo
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.init(r: 14, g:142, b: 243)))
                Text("0.50 \(viewModel.sources.AUR)")
                    .font(.regular(15))
                    .foreground(.black())
            }
        }

        ToolbarItem(placement: .principal) {
            HStack(spacing: 4) {
                Text(viewModel.sources.chats)
                    .multilineTextAlignment(.center)
                    .font(.bold(17))
                    .foreground(.black())
                    .accessibilityAddTraits(.isHeader)
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 4) {
                Button {
                    createRoomSelected.toggle()
                } label: {
                    viewModel.sources.squareAndPencil
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(r: 14, g:142, b: 243)))
                }
                Button(action: {
                            actionSheet?.show()
                }, label: {
                    viewModel.sources.ellipsisCircle
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(14, 142, 243)))
                })
                .padding(.trailing, 0)
            }
        }
    }
}
