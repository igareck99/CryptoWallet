import SwiftUI

// MARK: - ProfileBackgroundView

struct ProfileBackgroundView: View {

    // MARK: - Internal Properties

	@StateObject var viewModel = ProfileViewModel(
		userSettings: UserDefaultsService.shared,
		keychainService: KeychainService.shared
	)
    @StateObject var personalizationViewModel: PersonalizationViewModel

    // MARK: - Private Properties

    @State private var showAllSocial = false
    @State private var showSafari = false
    @State private var safariAddress = ""

    // MARK: - Body

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.personalizationBackground())
                        .font(.bold(15))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        personalizationViewModel.send(.onProfile)
                    }, label: {
                        Text(R.string.localizable.profileDetailRightButton())
                            .font(.bold(15))
                            .foreground(.blue())
                    })
                }
            }
            .navigationBarColor(.white(), isBlured: false)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.send(.onAppear)
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
                placeholder: { thumbnail },
                result: { Image(uiImage: $0).resizable() }
            )
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(50)
        }
    }

    private var photosView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 1.5), count: 3), alignment: .center, spacing: 1.5) {
            ForEach(0..<viewModel.profile.photos.count, id: \.self) { index in
                VStack(spacing: 0) {
                    viewModel.profile.photos[index]
                        .resizable()
                        .scaledToFill()
                }
            }
        }
    }

    private var socialView: some View {
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

    private var addSocialView: some View {
        Button(action: {
        }, label: {
            Text(R.string.localizable.profileAdd())
                .font(.regular(15))
                .foreground(.blue())
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
        })
            .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.blue, lineWidth: 1)
            )
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 24)
    }

    private var setBackgroundView: some View {
        VStack(spacing: 0) {
            Spacer()
            Button(action: {
                personalizationViewModel.send(.onProfile)
            }, label: {
                Text(R.string.localizable.profileBackgroundPreviewSetBackground())
                    .font(.regular(15))
                    .foreground(.white())
                    .frame(maxWidth: .infinity, minHeight: 68, idealHeight: 68, maxHeight: 68)
            })
                .frame(maxWidth: .infinity, minHeight: 68, idealHeight: 68, maxHeight: 68)
                .background(.black())
        }
        .ignoresSafeArea()
    }

    private var infoView: some View {
        VStack(spacing: 2) {
            HStack(spacing: 0) {
                Text(viewModel.profile.status)
                    .font(.regular(15))
                    .foreground(.black())
                Spacer()
            }
            HStack(spacing: 0) {
                Text("https://www.ikea.com/ru/ru/campaigns/actual-information-pub21f86b70")
                    .font(.regular(15))
                    .foreground(.blue())
                    .onTapGesture {
                    }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 16)
        .padding(.bottom, 24)
    }

    private var content: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        avatarView
                        socialView
                        Spacer()
                    }
                    .padding(.top, 27)
                    .padding(.leading, 16)
                    .padding(.bottom, 24)
                    infoView
                    addSocialView
                }
                .background(.white())

                photosView
                    .padding(.top, -9)
            }

            ZStack {
                setBackgroundView
            }
            .ignoresSafeArea()
        }
        .background(
            personalizationViewModel.user.backGround
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}
