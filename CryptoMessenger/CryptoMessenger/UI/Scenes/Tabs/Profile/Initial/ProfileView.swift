import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileViewModel

    // MARK: - Private Properties

    @State private var popupSelected = false
    @State private var showMenu = false
    @State private var showProfileDetail = false
    @State private var showCopyNicknameAlert = false
    @State private var showSafari = false
    @State private var showImagePicker = false
    @State private var safariAdress = ""

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
                            showCopyNicknameAlert.toggle()
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
            .navigationBarColor(.white(), isBlured: false)

//            .background(
//                EmptyNavigationLink(destination: ProfileDetailView(viewModel: .init()), isActive: $showProfileDetail)
//            )
            .onAppear {
                viewModel.send(.onAppear)
            }
            .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(link: $safariAdress)
        })
            .sheet(isPresented: $showImagePicker) {
                NavigationView {
                    ImagePickerView(selectedImage: $viewModel.selectedImage, onSelectImage: { image in
                        guard let image = image else { return }
                        self.viewModel.addPhoto(image: image)
                    })
                        .ignoresSafeArea()
                        .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .alert(isPresented: $showCopyNicknameAlert) { Alert(title: Text(R.string.localizable.profileCopied())) }
            .popup(
                isPresented: $showMenu,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: .black.opacity(0.4),
                dismissCallback: { showTabBar() },
                view: {
                    ProfileSettingsMenuView(balance: "0.50 AUR", onSelect: { type in
                        switch type {
                        case .profile:
                            vibrate()
                            hideTabBar()
                            viewModel.send(.onProfileScene)
                        case .personalization:
                            vibrate()
                            hideTabBar()
                            viewModel.send(.onPersonalization)
                        default:
                            break
                        }
                    })
                        .frame(height: 712, alignment: .center)
                        .background(
                            CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                                .fill(Color(.white()))
                        )
                }
            )
            .popup(
                isPresented: $popupSelected,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: Color(.black(0.4)),
                dismissCallback: { showTabBar() },
                view: {
                    BuyView()
                        .frame(height: 375, alignment: .center)
                        .background(
                            CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                                .fill(Color(.white()))
                        )
                }
            )
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
                                        ForEach(viewModel.socialList.listData) { item in
                                            switch item.networkType {
                                            case .twitter:
                                                Button(action: {
                                                    showSafari = true
                                                    safariAdress = item.url
                                                }, label: {
                                                    R.image.profile.twitter.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            case .instagram:
                                                Button(action: {
                                                    showSafari = true
                                                    safariAdress = item.url
                                                }, label: {
                                                    R.image.profile.instagram.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            case .facebook:
                                                Button(action: {
                                                    showSafari = true
                                                    safariAdress = item.url
                                                }, label: {
                                                    R.image.profile.facebook.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            case .webSite:
                                                Button(action: {
                                                    showSafari = true
                                                    safariAdress = item.url
                                                }, label: {
                                                    R.image.profile.website.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            case .telegram:
                                                Button(action: {
                                                    showSafari = true
                                                    safariAdress = item.url
                                                }, label: {
                                                    R.image.profile.website.image
                                                }).frame(width: 32, height: 32, alignment: .center)
                                                    .background(.blue())
                                                    .cornerRadius(16)
                                            }
                                        }
                                    }
                                    case true:
                                        Button(R.string.localizable.profileAddSocial()) {
                                        }
                                        .frame(width: 160, height: 32)
                                        .font(.regular(15))
                                        .foreground(.blue())
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
                                        safariAdress = "https://www.ikea.com/ru/ru/campaigns/actual-information-pub21f86b70"
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
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                            photosView

                            FooterView(popupSelected: $popupSelected)
                                .padding([.leading, .trailing], 16)
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
            if let url = viewModel.profile.avatar {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        thumbnail
                    }
                }
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(50)
            } else {
                thumbnail
            }
        }
    }

    private var photosView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 1.5), count: 3), alignment: .center, spacing: 1.5) {
            ForEach(0..<viewModel.profile.photos.count, id: \.self) { index in
                VStack(spacing: 0) {
                    viewModel.profile.photos[index]
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width - 3) / 3,
                               height: (UIScreen.main.bounds.width - 3) / 3)
                        .scaledToFill()
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
