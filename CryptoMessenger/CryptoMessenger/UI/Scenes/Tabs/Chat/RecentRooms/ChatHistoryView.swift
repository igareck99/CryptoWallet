import Combine
import SwiftUI

// swiftlint: disable all
protocol ChatHistoryViewDelegate: ObservableObject {

	var rooms: [AuraRoom] { get }
    
    var isLoading: Bool { get set }
    
    var leaveState: [String: Bool] { get }

	var groupAction: GroupAction? { get set }

	var sources: ChatHistorySourcesable.Type { get }

	var eventSubject: PassthroughSubject<ChatHistoryFlow.Event, Never> { get }

	func rooms(with filter: String) -> [AuraRoom]

	func markAllAsRead()
    
    func fromCurrentSender(room: AuraRoom) -> Bool
    
    func joinRoom(_ roomId: String, _ openChat: Bool)
    
    func findRooms(with filter: String,
                   completion: @escaping ([MatrixChannel]) -> Void)
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
    @State private var isNavBarHidden = false
	@State private var actionSheet: IOActionSheet?
    @State private var isRotating = 0.0

	private var searchResults: [AuraRoom] {
		viewModel.rooms(with: searchText)
	}
    
    @State private var gloabalSearch: [MatrixChannel] = []

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
                isNavBarHidden = false
			}
            .onTapGesture {
                hideKeyboard()
                withAnimation(.spring()) {
                    searching = false
                }
            }
            .onChange(of: searching, perform: { value in
                if value || !searchText.isEmpty {
                    isNavBarHidden = true
                } else {
                    isNavBarHidden = false
                }
            })
            .onChange(of: searchText, perform: { value in
                viewModel.isLoading = false
                withAnimation(.linear(duration: 0.64)) {
                    if !value.isEmpty || searching {
                        isNavBarHidden = true
                    } else {
                        isNavBarHidden = false
                    }
                }
                if !value.isEmpty {
                    viewModel.findRooms(with: value) { result in
                        self.gloabalSearch = result
                        viewModel.isLoading = false
                    }
                }
            })
            .onDisappear {
                showTabBar()
                searchText = ""
                searching = false
            }
            .navigationBarHidden(isNavBarHidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
				toolbarItems()
			}
			.sheet(isPresented: $createRoomSelected) {
				ChatCreateView(chatData: $chatData, viewModel: .init())
			}
	}

	// MARK: - Body Properties

    @ViewBuilder
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
            if viewModel.isLoading {
                loadingStateView()
            } else if searching && searchText.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    VStack(spacing: 4) {
                        viewModel.sources.emptyState
                        Text(viewModel.sources.searchEmpty)
                            .font(.regular(22))
                        Text(viewModel.sources.enterData)
                            .multilineTextAlignment(.center)
                            .font(.regular(15))
                            .foreground(.darkGray())
                    }
                    Spacer()
                }.frame(width: 248)
            } else if searchResults.isEmpty && !searchText.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    VStack(spacing: 4) {
                        viewModel.sources.noDataImage
                        Text(viewModel.sources.noResult)
                            .font(.regular(22))
                        Text(viewModel.sources.nothingFind)
                            .multilineTextAlignment(.center)
                            .font(.regular(15))
                            .foreground(.darkGray())
                    }
                    Spacer()
                }.frame(width: 248)
            } else if !searchText.isEmpty {
                List {
                    Section {
                        ForEach(searchResults) { value in
                            VStack(spacing: 0) {
                                ChatHistorySearchRow(name: value.summary.displayName?.firstUppercased ?? "",
                                                     numberUsers: 2,
                                                     avatarString: value.roomAvatar?.absoluteString ?? "")
                                .background(.white())
                                .onTapGesture {
                                    viewModel.eventSubject.send(.onShowRoom(value))
                                }.frame(height: 64)
                                Divider()
                                    .foregroundColor(Color(.darkGray()))
                                    .frame(height: 3)
                                    .padding(.leading, 64)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                    } header: {
                        HStack {
                            Text("Чаты")
                                .padding(16)
                                .font(.regular(13))
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 36)
                        .background(.paleBlue())
                    }
                    Section {
                        ForEach(gloabalSearch, id: \.self) { value in
                            VStack(spacing: 0) {
                                ChatHistorySearchRow(name: value.name,
                                                     numberUsers: value.numJoinedMembers,
                                                     avatarString: value.avatarUrl)
                                .background(.white())
                                .padding(.trailing, 32)
                                .onTapGesture {
                                    viewModel.joinRoom(value.roomId, true)
                                }
                                .frame(height: 64)
                                Divider()
                                    .foregroundColor(Color(.darkGray()))
                                    .frame(height: 3)
                                    .padding(.leading, 64)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                    } header: {
                        HStack {
                            Text("Глобальный поиск")
                                .font(.regular(13))
                                .padding(.leading, 16)
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 36)
                        .background(.paleBlue())
                    }
                }.listStyle(.plain)
            } else {
                List {
                    ForEach(searchResults) { room in
                        VStack(spacing: 0) {
                            ChatHistoryRow(room: room,
                                           isFromCurrentUser: viewModel.fromCurrentSender(room: room))
                            .background(.white())
                            .swipeActions(edge: .trailing) {
                                if !(viewModel.leaveState[room.room.roomId] ?? true) {
                                    Button {
                                        viewModel.eventSubject.send(.onDeleteRoom(room.room.roomId))
                                    } label: {
                                        viewModel.sources.chatReactionDelete
                                            .renderingMode(.original)
                                            .foreground(.blue())
                                    }.tint(.gray.opacity(0.1))
                                }
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
	}
    
    private var chats: some View {
        ForEach(searchResults) { room in
            VStack(spacing: 0) {
                ChatHistoryRow(room: room,
                               isFromCurrentUser: viewModel.fromCurrentSender(room: room))
                .background(.white())
                .swipeActions(edge: .trailing) {
                    if !(viewModel.leaveState[room.room.roomId] ?? true) {
                        Button {
                            viewModel.eventSubject.send(.onDeleteRoom(room.room.roomId))
                        } label: {
                            viewModel.sources.chatReactionDelete
                                .renderingMode(.original)
                                .foreground(.blue())
                        }.tint(.gray.opacity(0.1))
                    }
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
    
    @ViewBuilder
    private func loadingStateView() -> some View {
        VStack {
            Spacer()
            R.image.wallet.loader.image
                .rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(.linear(duration: 1)
                        .speed(0.4).repeatForever(autoreverses: false)) {
                            isRotating = 360.0
                        }
                }
                .onDisappear {
                    isRotating = 0
                }
            Spacer()
        }
    }
}

// MARK: - ChatHistoryViewState

enum ChatHistoryViewState {

    // MARK: - Cases
    
    case noData
    case emptySearch
    case chatsData
    case loading
}
