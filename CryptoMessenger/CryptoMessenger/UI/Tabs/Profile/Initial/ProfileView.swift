import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileViewModel
    @State var showImageEdtior = false
    @State var showImageViewer = false
    @State var selectedAvatarImage: UIImage?

    // MARK: - Private Properties

    @State private var popupSelected = false
    @State private var showProfileDetail = false
    @State private var showAlert = false
    @State private var showSafari = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var showLocationPicker = false
    @State private var safariAddress = ""
    @State private var showDeletePhotoAlert = false
    @State private var photoUrlForDelete = ""
    @State private var showAllSocial = false
    @State private var countUrlItems = 0
    @State private var showShareImage = false
    @State private var tabBarVisibility: Visibility = .visible

    // MARK: - Body
    
    var body: some View {
        content
            .onAppear {
                viewModel.send(.onProfileAppear)
            }
            .onChange(of: viewModel.selectedImage, perform: { _ in
                viewModel.send(.onImageEditor(isShowing: $showImageEdtior,
                                              image: $viewModel.selectedImage,
                                              viewModel: viewModel))
            })
            .fullScreenCover(isPresented: self.$showImageViewer,
                             content: {
                ImageViewerRemote(selectedItem: getTagItem(),
                                  imageURL: self.$viewModel.selectedPhoto,
                                  viewerShown: self.$showImageViewer,
                                  urls: viewModel.profile.photosUrls, onDelete: {
                    viewModel.deleteImageByUrl {
                        showImageViewer = false
                    }
                }, onShare: {
                    viewModel.shareImage {
                        showShareImage = true
                    }
                })
                    .ignoresSafeArea()
                    .sheet(isPresented: $showShareImage, content: {
                        FeedShareSheet(image: viewModel.imageToShare)
                            })
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(viewModel.resources.profileCopied))
            }
            .toolbar(.visible, for: .tabBar)
    }

    private var content: some View {
        NavigationView {
            ScrollView(popupSelected ? [] : .vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        avatarView
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.profile.name)
                                .font(.medium(15))
                                .foregroundColor(viewModel.resources.title)
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
                                                withAnimation(.linear(duration: 0.5), {
                                                    showAllSocial.toggle()
                                                })
                                            }, label: {
                                                R.image.photoEditor.dotes.image.resizable()
                                                    .frame(width: 16,
                                                           height: 15)
                                            }).frame(width: 32, height: 32, alignment: .center)
                                                .background(viewModel.resources.buttonBackground)
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
                                            withAnimation(.linear(duration: 0.5), {
                                                showAllSocial.toggle()
                                            })
                                        }, label: {
                                            R.image.photoEditor.dotes.image.resizable()
                                                .frame(width: 16,
                                                       height: 15)
                                        }).frame(width: 32, height: 32, alignment: .center)
                                            .background(viewModel.resources.buttonBackground)
                                            .cornerRadius(16)
                                    }
                                }
                                }
                                .frame(minHeight: 32,
                                       idealHeight: 32,
                                       maxHeight: 32)
                            case true:
                                Button(action: {
                                    viewModel.send(.onSocial)
                                }, label: {
                                    Text(viewModel.resources.profileAddSocial)
                                        .font(.regular(15))
                                        .foregroundColor(viewModel.resources.buttonBackground)
                                })
                                    .frame(width: 160, height: 32)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 61)
                                            .stroke(viewModel.resources.buttonBackground, lineWidth: 1)
                                    )
                            }
                            Text(viewModel.profile.phone)
                                .padding(.top, 1)
                        }
                    }
                    .padding(.top, 27)
                    .padding(.leading, 16)
                    if !viewModel.profile.status.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.profile.status)
                                .font(.regular(15))
                                .foregroundColor(viewModel.resources.title)
                        }.padding(.leading, 16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if viewModel.isEmptyFeed {
                    ChannelMediaEmptyState(image: viewModel.resources.emptyFeedImage,
                                           title: "Пока нет публикаций",
                                           description: "")
                } else {
                    photosView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                createToolBar()
            }
        }
    }

    private var avatarView: some View {
        ZStack {
            if let image = selectedAvatarImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .clipped()
            } else if let url = viewModel.profile.avatar {
                AsyncImage(
                    defaultUrl: url,
                    updatingPhoto: false,
                    url: nil,
                    placeholder: {
                        ZStack {
                            Circle()
                                .cornerRadius(50)
                                .frame(width: 100, height: 100)
                                .foregroundColor(viewModel.resources.buttonBackground)
                            ProgressView()
                                .tint(viewModel.resources.buttonBackground)
                                .frame(width: 50,
                                       height: 50)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
            } else {
                ZStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                        .foregroundColor(viewModel.resources.avatarBackgorund)
                    R.image.profile.avatarThumbnail.image
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
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
                            updatingPhoto: false,
                            url: nil,
                            placeholder: {
                                ProgressView()
                                    .tint(viewModel.resources.buttonBackground)
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
                                viewModel.selectedPhoto = url
                                showImageViewer = true
                            }
                    }
                }
            }
        }
    }

    // MARK: - Private Methods

    private func switchImagePicker() {
        viewModel.send(.onGallery(.photoLibrary))
    }

    private func switchCameraPicker() {
        viewModel.send(.onGallery(.camera))
    }

    private func getTagItem() -> Int {
        guard !viewModel.profile.photosUrls.isEmpty,
            let value = viewModel.profile.photosUrls.first(where: { $0 == viewModel.selectedPhoto }),
            let index = viewModel.profile.photosUrls.firstIndex(of: value)
        else {
            return 0
        }
        return index
    }
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text(viewModel.profile.nickname)
                .font(.bold(15))
                .lineLimit(1)
                .frame(minWidth: 0,
                       maxWidth: 0.78 * UIScreen.main.bounds.width)
                .onTapGesture {
                    UIPasteboard.general.string = viewModel.profile.nickname
                    showAlert = true
                }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            R.image.profile.camera.image
                .onTapGesture {
                    vibrate()
                    viewModel.send(.onFeedImageAdd)
                }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            R.image.profile.settings.image
                .onTapGesture {
                    vibrate()
                    viewModel.send(.onSettings($selectedAvatarImage))
                }
        }
    }
}
