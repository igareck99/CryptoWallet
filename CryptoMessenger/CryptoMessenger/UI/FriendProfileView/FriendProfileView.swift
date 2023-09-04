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

    // MARK: - Body

    var body: some View {
        content
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
                isPresented: $showMenu,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: viewModel.sources.backgroundFodding,
                view: {
                    FriendProfileSettingsView(viewModel: viewModel,
                                              onSelect: { type  in
                        vibrate()
                        switch type {
                        case .addNote:
                            showNotesView = true
                        case .addContact:
                            showCreateContact = true
                        default:
                            break
                        }
                    })
                    .background(
                        CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                            .fill(viewModel.sources.background)
                    )
                    .frame(height: 482)
                }
            )
            .popup(
                isPresented: $showNotesView,
                type: .toast,
                position: .bottom,
                closeOnTap: false,
                closeOnTapOutside: true,
                backgroundColor: viewModel.sources.backgroundFodding,
                view: {
                    NotesView(showNotes: $showNotesView)
                    .background(
                        CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                            .fill(viewModel.sources.background)
                    )
                    .frame(height: 375)
                }
            )
            .overlay(
                EmptyNavigationLink(
                    destination: CreateContactView(viewModel: CreateContactViewModel(),
                                                   nameSurnameText: viewModel.userId.name,
                                                   numberText: viewModel.profile.phone),
                    isActive: $showCreateContact
                )
            )
    }

    private var content: some View {
        ZStack {
            ScrollView(popupSelected ? [] : .vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        avatarView
                        VStack(alignment: .leading, spacing: 11) {
                            Text(viewModel.profile.nickname)
                                .font(.system(size: 15, weight: .medium))
                            switch viewModel.socialListEmpty {
                            case false:
                                ScrollView(!showAllSocial ? [] : .horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    switch showAllSocial {
                                    case false:
                                        if viewModel.existringUrls.count < 4 {
                                            ForEach(viewModel.profile.socialNetwork.filter({ !$0.url.isEmpty })) { item in
                                                SocialNetworkView(safariAddress: $safariAddress,
                                                                  showSafari: $showSafari,
                                                                  item: item)
                                            }
                                        } else {
                                            ForEach(viewModel.profile.socialNetwork.filter({ !$0.url.isEmpty })[0...2]) { item in
                                                if !item.url.isEmpty {
                                                    SocialNetworkView(safariAddress: $safariAddress,
                                                                      showSafari: $showSafari,
                                                                      item: item)
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
                                                SocialNetworkView(safariAddress: $safariAddress,
                                                                  showSafari: $showSafari,
                                                                  item: item)
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
                                }
                            case true:
                                EmptyView()
                            }
                            Text(viewModel.profile.phone)
                        }
                    }
                    .padding(.top, 27)
                    .padding(.leading, 16)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.profile.status)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(viewModel.sources.titleColor)
                        Text("https://www.ikea.com/ru/ru/campaigns/actual-information-pub21f86b70")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(viewModel.sources.buttonBackground)
                            .onTapGesture {
                                safariAddress = "https://www.ikea.com/ru/ru/" +
                                "campaigns/actual-information-pub21f86b70"
                                showSafari = true
                            }
                    }.padding(.leading, 16)
                    buttonsView
                        .padding(.top, 24)
                        .padding(.horizontal, 16)

                    photosView
                }
            }
        }
    }

    private var buttonsView: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.p2pVideoCallPublisher.send()
            }, label: {
                Text(R.string.localizable.friendProfileWrite())
                    .frame(idealWidth: (UIScreen.main.bounds.width - 44) / 2,
                           maxWidth: (UIScreen.main.bounds.width - 44) / 2,
                           minHeight: 44,
                           idealHeight: 44,
                           maxHeight: 44)
                    .font(.system(size: 15, weight: .regular))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.sources.buttonBackground, lineWidth: 1)
                    )
            })
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                .background(viewModel.sources.background)
            Button(action: {
            }, label: {
                Text(R.string.localizable.friendProfileCall())
                    .frame(idealWidth: (UIScreen.main.bounds.width - 44) / 2,
                           maxWidth: (UIScreen.main.bounds.width - 44) / 2,
                           minHeight: 44,
                           idealHeight: 44,
                           maxHeight: 44)
                    .font(.system(size: 15, weight: .regular))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.sources.buttonBackground, lineWidth: 1)
                    )
            })
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                .background(viewModel.sources.background)
        }
    }

    private var avatarView: some View {
        AsyncImage(
            defaultUrl: viewModel.profile.avatar,
            updatingPhoto: false,
            url: nil,
            placeholder: {
                ZStack {
                    Circle()
                        .background(viewModel.sources.avatarBackground)
                    viewModel.sources.avatarThumbnail
                }
            },
            result: {
                Image(uiImage: $0).resizable()
            }
        )
        .scaledToFill()
        .frame(width: 100, height: 100)
        .cornerRadius(50)
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
                                showImageViewer = true
                                viewModel.selectedPhoto = url
                            }
                    }
                }
            }
        }
    }

    // MARK: - Private methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showMenu.toggle()
            }, label: {
                viewModel.sources.settingsButton
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.userId.mxId)
                .font(.system(size: 15, weight: .bold))
                .lineLimit(1)
                .onTapGesture {
                    UIPasteboard.general.string = viewModel.userId.mxId
                    showAlert = true
                }
        }
    }
}
