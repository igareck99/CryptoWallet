import SwiftUI

// MARK: - ChatView

struct ChatView<ViewModel>: View where ViewModel: ChatViewModelProtocol {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State var isLeaveChannel = false

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                List {
                    ForEach(viewModel.displayItems, id: \.id) { item in
                        item.view()
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                    ForEach(viewModel.sendingEventsView, id: \.id) { item in
                        item.view()
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.inset)
                .onAppear {
                    viewModel.eventSubject.send(.onAppear)
                }
                .onReceive(viewModel.scrollIdPublisher, perform: { value in
                    withAnimation {
                        scrollView.scrollTo(value, anchor: .bottom)
                    }
                })
            }
            Spacer()
            inputView
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.eventSubject.send(.onAppear)
        }
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            createToolBar()
        }
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 0) {
                AsyncImage(
                    defaultUrl: viewModel.roomAvatarUrl,
                    updatingPhoto: true,
                    url: $viewModel.roomAvatarUrl,
                    isAvatarLoading: $viewModel.isAvatarLoading,
                    placeholder: {
                        ZStack {
                            Color.aliceBlue
                            Text(viewModel.roomName.firstLetter.uppercased())
                                .foregroundColor(.white)
                                .font(.title3Semibold20)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .frame(width: 36, height: 36)
                .cornerRadius(18)
                .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.roomName)
                        .lineLimit(1)
                        .font(.callout2Semibold16)
                        .foregroundColor(.chineseBlack)

                    HStack(spacing: 0) {
                        if viewModel.isDirect {
                            Text(
                                viewModel.isOnline ?
                                viewModel.resources.chatOnline :
                                    viewModel.resources.chatOffline
                            )
                            .lineLimit(1)
                            .font(.footnoteRegular13)
                            .foregroundColor(viewModel.isOnline ? .dodgerBlue : .chineseBlack04)
                        } else {
                            Text("Участники (\(viewModel.participants.count))")
                                .lineLimit(1)
                                .font(.footnoteRegular13)
                                .foregroundColor(.chineseBlack04)
                        }
                        Spacer()
                    }
                }
            }
            .background(Color.clear)
            .onTapGesture {
                viewModel.onNavBarTap(
                    chatData: $viewModel.chatData,
                    saveData: $viewModel.saveData,
                    isLeaveChannel: $isLeaveChannel
                )
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 8) {
                if viewModel.isVideoCallAvailable {
                    Button(action: {
                        viewModel.p2pVideoCallPublisher.send()
                    }, label: {
                        viewModel.resources.videoFill.tint(.chineseBlack)
                    }).disabled(!$viewModel.isVideoCallAvailablility.wrappedValue)
                }
                if viewModel.isVoiceCallAvailable {
                    Button(action: {
                        viewModel.p2pVoiceCallPublisher.send()
                    }, label: {
                        viewModel.resources.phoneFill.tint(.chineseBlack)
                    }).disabled(!$viewModel.isVoiceCallAvailablility.wrappedValue)
                }
                if viewModel.isGroupCall {
                    Button(action: {
                        viewModel.groupCallPublisher.send()
                    }, label: {
                        viewModel.resources.videoFill.tint(.chineseBlack)
                    })
                }
                /*
                if viewModel.getMenuStatus() {
                    Button(action: {
                        hideKeyboard()
                        cardGroupPosition = .custom(UIScreen.main.bounds.height - 250)
                    }, label: {
                        viewModel.resources.settingsButton
                    })
                    .padding(.trailing, 6)
                }
                */
            }
        }
    }

    private var inputView: some View {
        ChatInputViewModel(isWriteEnable: $viewModel.isAccessToWrite,
                           inputText: $viewModel.inputText,
                           activeEditMessage: $viewModel.activeEditMessage,
                           quickAction: $viewModel.quickAction,
                           replyDescriptionText: $viewModel.replyDescriptionText) {
            viewModel.sendMessage(.text, image: nil, url: nil,
                                  record: nil, location: nil, contact: nil)
        } onChatRoomMenu: {
            viewModel.showChatRoomMenu()
        } sendAudio: { record in
            viewModel.sendMessage(.audio, image: nil, url: nil,
                                  record: record, location: nil, contact: nil)
        }
        .view()
    }
}
