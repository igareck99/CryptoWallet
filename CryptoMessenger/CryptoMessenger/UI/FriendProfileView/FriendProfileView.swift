import SwiftUI

// MARK: - FriendProfileView

struct FriendProfileView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: FriendProfileViewModel
    @State var showImageViewer = false
    @State var showNotesView = false
    @State var showCreateContact = false

    // MARK: - Private Properties

    @State private var popupSelected = false
    @State private var showMenu = false
    @State private var showProfileDetail = false
    @State private var showAlert = false
    @State private var showSafari = false
    @State private var showLocationPicker = false
    @State private var safariAddress = ""
    @State private var showAllSocial = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                createToolBar()
            }
            .onAppear {
                viewModel.send(.onProfileAppear)
            }
            .toolbar(.hidden, for: .tabBar)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(viewModel.sources.profileCopied))
            }
            .popup(
                isPresented: viewModel.isSnackbarPresented,
                alignment: .bottom
            ) {
                Snackbar(
                    text: viewModel.messageText,
                    color: .spanishCrimson
                )
            }
            .fullScreenCover(isPresented: $viewModel.showWebView) {
                viewModel.safari
            }
            .sheet(isPresented: $showNotesView, content: {
                NotesView(viewModel: NotesViewModel(userId: viewModel.userId))
                .background(
                    CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                        .fill(viewModel.sources.background)
                )
                .presentationDetents([.height(341)])
                .onDisappear {
                    viewModel.loadUserNote()
                }
            })
    }

    private var content: some View {
        GeometryReader { geometry in
            ScrollView(popupSelected ? [] : .vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                    HStack(alignment: .center, spacing: 16) {
                        avatarView
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer()
                            Text(viewModel.profile.name)
                                .font(.callout2Semibold16)
                                .lineLimit(1)
                            Text(viewModel.profile.phone)
                                .padding(.top, 2)
                                .lineLimit(1)
                                .font(.subheadlineRegular15)
                            switch viewModel.profile.socialNetwork.isEmpty {
                            case false:
                                ScrollView(!showAllSocial ? [] : .horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        switch showAllSocial {
                                        case false:
                                            if viewModel.profile.socialNetwork.count < 4 {
                                                ForEach(viewModel.profile.socialNetwork.filter({ !$0.url.isEmpty })) { item in
                                                    SocialNetworkView(item: item) {
                                                        viewModel.onSafari(item.url)
                                                    }
                                                }
                                            } else {
                                                ForEach(viewModel.profile.socialNetwork) { item in
                                                    if !item.url.isEmpty {
                                                        SocialNetworkView(item: item) {
                                                            viewModel.onSafari(item.url)
                                                        }
                                                    }
                                                }
                                                Button(action: {
                                                    showAllSocial.toggle()
                                                }, label: {
                                                    viewModel.sources.settingsButton.resizable()
                                                        .frame(width: 16,
                                                               height: 15)
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(viewModel.sources.buttonBackground)
                                                    .cornerRadius(16)
                                            }
                                        case true:
                                            ForEach(viewModel.profile.socialNetwork) { item in
                                                if !item.url.isEmpty {
                                                    SocialNetworkView(item: item) {
                                                        viewModel.onSafari(item.url)
                                                    }
                                                }
                                            }
                                            Button(action: {
                                                showAllSocial.toggle()
                                            }, label: {
                                                viewModel.sources.settingsButton.resizable()
                                                    .frame(width: 16,
                                                           height: 15)
                                            }).frame(width: 32, height: 32, alignment: .center)
                                                .background(viewModel.sources.buttonBackground)
                                                .cornerRadius(16)
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                            case true:
                                EmptyView()
                            }
                            Spacer()
                        }
                    }
                    .padding([.leading, .top], 16)
                    if !viewModel.profile.status.isEmpty {
                        Text(viewModel.profile.status)
                            .font(.calloutRegular16)
                            .foregroundColor(viewModel.sources.titleColor)
                            .padding(.top, 20)
                            .padding(.leading, 16)
                    }
                    if !viewModel.profile.note.isEmpty {
                        notesView.padding(.top, 10)
                    }
                    if !viewModel.profile.mxId.isEmpty {
                        LargeButton(title: R.string.localizable.friendProfileWrite(),
                                    backgroundColor: .white,
                                    foregroundColor: .dodgerBlue) {
                            print("Hello World")
                        }
                                    .padding(.top, 16)
                    }
                    VStack(alignment: .center, spacing: 0) {
                        Divider()
                        if viewModel.profile.photosUrls.isEmpty {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ChannelMediaEmptyState(image: R.image.media.noMedia.image,
                                                           title: "Пока нет публикаций",
                                                           description: "")
                                    Spacer()
                                }
                                Spacer()    
                            }
                        } else {
                            photosView
                        }
                    }
                    .frame(maxHeight: geometry.size.height)
                    .padding(.top, 16)
                }
            }.frame(width: geometry.size.width)
        }
    }
    
    private var placeholderPhotoView: some View {
        ZStack(alignment: .center) {
            Circle()
                .cornerRadius(50)
                .frame(width: 100, height: 100)
                .foregroundColor(Color.aliceBlue)
            R.image.chatHistory.personAvatar.image
        }
    }

    private var avatarView: some View {
        AsyncImage(
            defaultUrl: viewModel.profile.avatar,
            updatingPhoto: false,
            url: nil,
            placeholder: {
                placeholderPhotoView
            },
            result: {
                Image(uiImage: $0).resizable()
            }
        )
        .scaledToFill()
        .clipShape(Circle())
        .frame(width: 100, height: 100)
    }
    
    private var notesView: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.ghostWhite)
                .frame(minHeight: 60)
                .padding(.horizontal, 16)
            Text(viewModel.profile.note)
                .padding(.leading, 24)
                .padding(.trailing, 53)
                .padding([.bottom, .top], 10)
        }
    }

    private var photosView: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 1.5), count: 3), alignment: .center, spacing: 1.5) {
                ForEach(viewModel.profile.photosUrls, id: \.self) { url in
                    VStack(spacing: 0) {
                        let width = (geometry.size.width - 3) / 3
                        AsyncImage(
                            defaultUrl: url,
                            placeholder: {
                                ProgressView()
                                    .tint(viewModel.sources.buttonBackground)
                                    .frame(width: width, height: width)
                                    .scaledToFill()
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .frame(width: width, height: width)
                            .clipped()
                            .onTapGesture {
                                viewModel.onImageViewer(url)
                            }
                    }
                }
            }
        }
    }

    // MARK: - Private methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 16) {
                R.image.navigation.backButton.image
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                Text(viewModel.profile.nicknameDisplay)
                    .font(.bodyRegular17)
                    .lineLimit(1)
                    .frame(minWidth: 0,
                           maxWidth: 0.5 * UIScreen.main.bounds.width)
                    .onTapGesture {
                        UIPasteboard.general.string = viewModel.profile.nickname
                        showAlert = true
                    }
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showNotesView.toggle()
            }, label: {
                R.image.profile.friendProfileWrite.image
            })
        }
    }
}
