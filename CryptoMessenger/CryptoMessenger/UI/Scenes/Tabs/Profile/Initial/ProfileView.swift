import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileViewModel
    @State var showImageEdtior = false
    @State var showImageViewer = false

    // MARK: - Private Properties

    @State private var popupSelected = false
    @State private var showMenu = false
    @State private var showProfileDetail = false
    @State private var showAlert = false
    @State private var showSafari = false
    @State private var showImagePicker = false
    @State private var safariAddress = ""
    @State private var showDeletePhotoAlert = false
    @State private var photoUrlForDelete = ""
    @State private var showAllSocial = false
    @State private var countUrlItems = 0

    // MARK: - Body

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.profile.nickname)
                        .font(.bold(15))
                        .onTapGesture {
                            UIPasteboard.general.string = viewModel.profile.nickname
                            showAlert = true
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    R.image.profile.settings.image
                        .onTapGesture {
                            hideTabBar()
                            vibrate()
                            showMenu = true
                        }
                }
            }
            .onAppear {
                viewModel.send(.onAppear)
                showTabBar()
            }
            .onChange(of: viewModel.selectedImage, perform: { _ in
                showImageEdtior = true
            })
            .fullScreenCover(isPresented: $showSafari) {
                SFSafariViewWrapper(link: $safariAddress)
            }
            .fullScreenCover(isPresented: $showImageViewer,
                             content: {
                FeedImageViewerView(
                    selectedPhoto: $viewModel.selectedPhoto,
                    showImageViewer: $showImageViewer,
                    profileViewModel: viewModel,
                    imageToShare: $viewModel.imageToShare)
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $viewModel.selectedImage)
                    .ignoresSafeArea()
                    .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .fullScreenCover(isPresented: $showImageEdtior,
                             content: {
                ImageEditor(theimage: $viewModel.selectedImage,
                            isShowing: $showImageEdtior,
                            viewModel: viewModel)
                    .ignoresSafeArea()
            })
            .alert(isPresented: $showAlert) {
                 Alert(title: Text(R.string.localizable.profileCopied()))
            }
            .onChange(of: showMenu, perform: { value in
                if !value {
                    showTabBar()
                } else {
                    hideTabBar()
                }
            })
            .popup(
                isPresented: $showMenu,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: .black.opacity(0.4),
                view: {
                    ProfileSettingsMenuView(balance: "0.50 AUR", onSelect: { type in
                        vibrate()
                        viewModel.send(.onShow(type))
                    })
                        .onAppear {
                            hideTabBar()
                        }
                        .onDisappear {
                            showTabBar()
                        }
                        .frame(height: UIScreen.main.bounds.height - 100)
                        .background(
                            CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                                .fill(Color(.white()))
                        )
                }
            )
    }

    private var content: some View {
        ZStack {
            ScrollView(popupSelected ? [] : .vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        avatarView
                        VStack(alignment: .leading, spacing: 11) {
                            Text(viewModel.profile.name)
                                .font(.medium(15))
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
                                                R.image.navigation.settingsButton.image.resizable()
                                                    .frame(width: 16,
                                                           height: 15)
                                            }).frame(width: 32, height: 32, alignment: .center)
                                                .background(.blue())
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
                                            R.image.navigation.settingsButton.image.resizable()
                                                .frame(width: 16,
                                                       height: 15)
                                        }).frame(width: 32, height: 32, alignment: .center)
                                            .background(.blue())
                                            .cornerRadius(16)
                                    }
                                }
                                }
                            case true:
                                Button(action: {
                                    viewModel.send(.onSocial)
                                }, label: {
                                    Text(R.string.localizable.profileAddSocial())
                                        .font(.regular(15))
                                        .foreground(.blue())
                                })
                                    .frame(width: 160, height: 32)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 61)
                                            .stroke(Color(.blue()), lineWidth: 1)
                                    )
                            }
                            Text(viewModel.profile.phone)
                        }
                    }
                    .padding(.top, 27)
                    .padding(.leading, 16)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.profile.status)
                            .font(.regular(15))
                            .foreground(.black())
                        Text("https://www.ikea.com/ru/ru/campaigns/actual-information-pub21f86b70")
                            .font(.regular(15))
                            .foreground(.blue())
                            .onTapGesture {
                                safariAddress = "https://www.ikea.com/ru/ru/" +
                                "campaigns/actual-information-pub21f86b70"
                                showSafari = true
                            }
                    }.padding(.leading, 16)

                    Button(action: {
                        showImagePicker = true
                    }, label: {
                        Text(R.string.localizable.profileAdd())
                            .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                            .font(.regular(15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.blue, lineWidth: 1)
                            )
                    })
                        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                        .background(.white())
                        .padding(.horizontal, 16)

                    photosView
                }
            }
        }
    }

    private var avatarView: some View {
        let thumbnail = ZStack {
            Circle()
                .frame(width: 100, height: 100)
                .background(.blue(0.1))
            R.image.profile.avatarThumbnail.image
        }

        return ZStack {
            AsyncImage(
                url: viewModel.profile.avatar,
                placeholder: {
                    if viewModel.profile.avatar != nil {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .background(.blue(0.1))
                            .tint(Color(.blue()))
                    } else {
                        thumbnail
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
    }

    private var photosView: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 1.5), count: 3), alignment: .center, spacing: 1.5) {
                ForEach(viewModel.profile.photosUrls, id: \.self) { url in
                    VStack(spacing: 0) {
                        let width = (geometry.size.width - 3) / 3
                        AsyncImage(
                            url: url,
                            placeholder: {
                                ProgressView()
                                    .tint(Color(.blue()))
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
}

// MARK: - FooterView

struct FooterView: View {

    // MARK: - Internal Properties

    @Binding var popupSelected: Bool

    // MARK: - Body

    var body: some View {
        Button(action: {
            hideTabBar()
            popupSelected.toggle()
        }, label: {
            Text(R.string.localizable.profileBuyCell())
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                .font(.regular(15))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
        })
            .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
            .background(.white())
    }
}
