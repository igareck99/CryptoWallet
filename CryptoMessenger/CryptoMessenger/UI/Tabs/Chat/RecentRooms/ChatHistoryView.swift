import Combine
import SwiftUI

// MARK: - ChatHistoryView

struct ChatHistoryView<ViewModel>: View where ViewModel: ChatHistoryViewDelegate {

    // MARK: - Internal Properties

	@StateObject var viewModel: ViewModel

	// MARK: - Private Properties

	@State private var searchText = ""
	@State private var searching = false
	@State private var chatData = ChatData()
    @State private var isNavBarHidden = false
    @State private var isRotating = 0.0
    @State private var showReadAll = false

	private var searchResults: [ChatHistoryData] {
		viewModel.rooms(with: searchText)
	}
    
    private var chatHistoryRooms: [ChatHistoryData] {
        viewModel.chatHistoryRooms
    }
    
    @State private var gloabalSearch: [MatrixChannel] = []

	// MARK: - Body
    
    var body: some View {
        content()
    }

    @ViewBuilder
    func content() -> some View {
        content1
            .confirmationDialog("", isPresented: $showReadAll) {
                Button(viewModel.sources.readAll, action: {
                    viewModel.markAllAsRead()
                    isNavBarHidden = false
                })
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
                searchText = ""
                searching = false
            }
            .navigationBarHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
				toolbarItems()
			}
	}

	// MARK: - Body Properties

    var content1: some View {

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
                                ChatHistorySearchRow(name: value.roomName.firstUppercased,
                                                     numberUsers: value.numberUsers,
                                                     avatarString: value.roomAvatar?.absoluteString ?? "")
                                .background(.white())
                                .onTapGesture {
                                    viewModel.eventSubject.send(.onShowRoom(value.roomId))
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
                    ForEach(viewModel.chatHistoryRooms) { room in
                        room.view()
                            .background(.white())
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.eventSubject.send(.onRoomActions(room))
                                } label: {
                                    EmptyView()
                                }.tint(.gray.opacity(0.1))
                            }.onTapGesture {
                                viewModel.eventSubject.send(.onShowRoom(room.roomId))
                            }.frame(width: nil, height: 76)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                }.listStyle(.plain)
            }
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
                    viewModel.eventSubject.send(.onCreateChat($chatData))
                } label: {
                    viewModel.sources.squareAndPencil
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(r: 14, g:142, b: 243)))
                }
                Button(action: {
                    showReadAll = true
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
                    withAnimation(
                        .linear(duration: 1)
                        .speed(0.4)
                        .repeatForever(autoreverses: false)
                    ) {
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
