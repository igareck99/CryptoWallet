import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileViewModel

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
                            showAlert.toggle()
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    R.image.profile.settings.image
                        .onTapGesture {
                            vibrate()
                            hideTabBar()
                            showMenu.toggle()
                        }
                }
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
            .fullScreenCover(isPresented: $showSafari) {
                SFSafariViewWrapper(link: $safariAddress)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $viewModel.selectedImage)
                    .ignoresSafeArea()
                    .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .alert(isPresented: $showAlert) {
                switch showDeletePhotoAlert {
                case false:
                    return Alert(title: Text(R.string.localizable.profileCopied()))
                case true:
                    let primaryButton = Alert.Button.default(Text("Да")) {
                        viewModel.deletePhoto(url: photoUrlForDelete)
                    }
                    let secondaryButton = Alert.Button.destructive(Text("Нет")) {
                        photoUrlForDelete = ""
                    }
                    return Alert(title: Text("Удалить фото?"),
                                 message: Text(""),
                                 primaryButton: primaryButton,
                                 secondaryButton: secondaryButton)
                }
            }
//            .popup(
//                isPresented: $showMenu,
//                type: .toast,
//                position: .bottom,
//                closeOnTap: true,
//                closeOnTapOutside: true,
//                backgroundColor: .black.opacity(0.4),
//                dismissCallback: { showTabBar() },
//                view: {
//                    ProfileSettingsMenuView(balance: "0.50 AUR", onSelect: { type in
//                        vibrate()
//                        hideTabBar()
//                        viewModel.send(.onShow(type))
//                    })
//                        .frame(height: 712)
//                        .background(
//                            CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
//                                .fill(Color(.white()))
//                        )
//                }
//            )
//            .popup(
//                isPresented: $popupSelected,
//                type: .toast,
//                position: .bottom,
//                closeOnTap: true,
//                closeOnTapOutside: true,
//                backgroundColor: Color(.black(0.4)),
//                dismissCallback: { showTabBar() },
//                view: {
//                    BuyView()
//                        .frame(height: 375, alignment: .center)
//                        .background(
//                            CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
//                                .fill(Color(.white()))
//                        )
//                }
//            )
    }

    private var content: some View {
        ZStack {
            ScrollView(popupSelected ? [] : .vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        avatarView
                        VStack(alignment: .leading, spacing: 11) {
                            Text(viewModel.profile.name)
                                .font(.medium(15))
                            switch viewModel.socialListEmpty {
                            case false:
                                HStack(spacing: 8) {
                                    ForEach(SocialKey.allCases) { item in
                                        switch item {
                                        case .twitter:
                                            if !(viewModel.profile.socialNetwork[.twitter] ?? "").isEmpty {
                                                Button(action: {
                                                    showSafari = true
                                                    safariAddress = viewModel.profile.socialNetwork[.twitter] ?? ""
                                                }, label: {
                                                    R.image.profile.twitter.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            }
                                        case .facebook:
                                            if !(viewModel.profile.socialNetwork[.facebook] ?? "").isEmpty {
                                                Button(action: {
                                                    showSafari = true
                                                    safariAddress = viewModel.profile.socialNetwork[.facebook] ?? ""
                                                }, label: {
                                                    R.image.profile.facebook.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            }
                                        case .instagram:
                                            if !(viewModel.profile.socialNetwork[.instagram] ?? "").isEmpty {
                                                Button(action: {
                                                    showSafari = true
                                                    safariAddress = viewModel.profile.socialNetwork[.instagram] ?? ""
                                                }, label: {
                                                    R.image.profile.instagram.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            }
                                        case .vk:
                                            if !(viewModel.profile.socialNetwork[.vk] ?? "").isEmpty {
                                                Button(action: {
                                                    showSafari = true
                                                    safariAddress = viewModel.profile.socialNetwork[.vk] ?? ""
                                                }, label: {
                                                    R.image.profile.website.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            }
                                        }
                                    }
                                }
                            case true:
                                Button(action: {
                                    viewModel.addSocial(socialKey: .twitter,
                                                        socialValue: "https://twitter.com")
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

                    if !viewModel.profile.photos.isEmpty {
                        FooterView(popupSelected: $popupSelected)
                            .padding(.horizontal, 16)
                    }

                }

            }
        }
    }

    private var avatarView: some View {
        let thumbnail = ZStack {
            Circle()
                .frame(width: 100, height: 100)
                .foreground(.blue(0.1))
            R.image.profile.avatarThumbnail.image
        }

        return ZStack {
            AsyncImage(
                url: viewModel.profile.avatar,
                placeholder: {
                    if (viewModel.profile.avatar != nil) {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .background(.blue(0.1))
                            .tint(Color(.blue()))
                            .scaledToFill()
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
                ForEach(0..<viewModel.profile.photosUrls.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        let width = (geometry.size.width - 3) / 3
                        AsyncImage(
                            url: viewModel.profile.photosUrls[index],
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
                                showAlert = true
                                showDeletePhotoAlert = true
                                photoUrlForDelete = viewModel.profile.photosUrls[index].absoluteString
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
