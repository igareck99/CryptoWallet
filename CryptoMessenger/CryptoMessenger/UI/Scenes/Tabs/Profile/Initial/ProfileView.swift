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
    @State private var showMenu = false
    @State private var showProfileDetail = false
    @State private var showAlert = false
    @State private var showSafari = false
    @State private var showActionImageAlert = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var showLocationPicker = false
    @State private var safariAddress = ""
    @State private var showDeletePhotoAlert = false
    @State private var photoUrlForDelete = ""
    @State private var showAllSocial = false
    @State private var countUrlItems = 0
    @State private var showShareImage = false

    // MARK: - Body

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
                    R.image.profile.settings.image
                        .onTapGesture {
                            hideTabBar()
                            vibrate()
                            showMenu.toggle()
                        }
                }
            }
            .toolbarBackground(showMenu ? Color(.black(0.4)) : .white, for: .navigationBar)
            .toolbarBackground(showMenu ? .visible : .hidden, for: .navigationBar)
            .onAppear {
                viewModel.send(.onProfileAppear)
                if !showMenu {
                    showTabBar()
                }
            }
            .onChange(of: viewModel.selectedImage, perform: { _ in
                showImageEdtior = true
            })
            .onChange(of: showMenu, perform: { value in
                if value && viewModel.isVoiceCallAvailablility {
                    hideTabBar()
                }
            })
            .actionSheet(isPresented: $showActionImageAlert) {
                ActionSheet(title: Text(""),
                            message: nil,
                            buttons: [
                                .cancel(),
                                .default(
                                    Text(R.string.localizable.profileFromGallery()),
                                    action: switchImagePicker
                                ),
                                .default(
                                    Text(R.string.localizable.profileFromCamera()),
                                    action: switchCameraPicker
                                )
                            ]
                )
            }
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
            .fullScreenCover(isPresented: $showCameraPicker,
                             content: {
                ImagePickerView(selectedImage: $viewModel.selectedImage,
                                sourceType: .camera)
                .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                             content: {
                ImagePickerView(selectedImage: $viewModel.selectedImage)
                    .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            })
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
            .popup(
                isPresented: $showMenu,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: .black.opacity(0.4),
                dismissCallback: {
                    self.showTabBar()
                },
                view: {
                    ProfileSettingsMenuView(balance: "0.50 AUR",
                                            onSelect: { type in
                        vibrate()
                        if type == .profile {
                            viewModel.send(.onShowProfileDetail($selectedAvatarImage))
                        } else {
                            viewModel.send(.onShow(type))
                        }
                    })
                    .frame(height: viewModel.menuHeight )
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
                        VStack(alignment: .leading, spacing: 10) {
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
                                                withAnimation(.linear(duration: 0.5), {
                                                    showAllSocial.toggle()
                                                })
                                            }, label: {
                                                R.image.photoEditor.dotes.image.resizable()
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
                                            withAnimation(.linear(duration: 0.5), {
                                                showAllSocial.toggle()
                                            })
                                        }, label: {
                                            R.image.photoEditor.dotes.image.resizable()
                                                .frame(width: 16,
                                                       height: 15)
                                        }).frame(width: 32, height: 32, alignment: .center)
                                            .background(.blue())
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
                                .padding(.top, 1)
                        }
                    }
                    .padding(.top, 27)
                    .padding(.leading, 16)
                    if !viewModel.profile.status.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.profile.status)
                                .font(.regular(15))
                                .foreground(.black())
                            //                        Text("https://www.ikea.com/ru/ru/campaigns/actual-information-pub21f86b70")
                            //                            .font(.regular(15))
                            //                            .foreground(.blue())
                            //                            .onTapGesture {
                            //                                safariAddress = "https://www.ikea.com/ru/ru/" +
                            //                                "campaigns/actual-information-pub21f86b70"
                            //                                showSafari = true
                            //                            }
                        }.padding(.leading, 16)
                    }
                    Button(action: {
                        showActionImageAlert = true
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
                        .background(Color.primaryColor)
                        .padding(.horizontal, 16)
                    photosView
                }
            }
        }.background(Color.primaryColor)
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
                                .foreground(.blue(0.1))
                            ProgressView()
                                .tint(Color(.blue()))
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
                        .foreground(.blue(0.1))
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
        showImagePicker = true
    }

    private func switchCameraPicker() {
        showCameraPicker = true
    }
    
    private func getTagItem() -> Int {
        if !viewModel.profile.photosUrls.isEmpty {
            guard let value = viewModel.profile.photosUrls.first(where: { $0 == viewModel.selectedPhoto } ) else { return 0 }
            guard let index = viewModel.profile.photosUrls.index(of: value) else { return 0 }
            return index
        }
        return 0
    }
}
