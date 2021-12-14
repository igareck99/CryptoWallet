import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileViewModel

    // MARK: - Private Properties

    @State private var popupSelected = false
    @State private var showMenu = false
    @State private var showProfileDetail = false

    // MARK: - Body

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.profile.nickname)
                        .font(.bold(15))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    R.image.profile.settings.image
                        .onTapGesture {
                            hideTabBar()
                            showMenu.toggle()
                        }
                }
            }
            .background(
                EmptyNavigationLink(destination: ProfileDetailView(viewModel: .init()), isActive: $showProfileDetail)
            )
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
                            hideTabBar()
                            showProfileDetail.toggle()
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
        GeometryReader { geometry in
            ZStack {
                ScrollView(popupSelected ? [] : .vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 16) {
                                avatarView

                                VStack(alignment: .leading, spacing: 11) {
                                    Text(viewModel.profile.name)
                                        .font(.medium(15))

                                    Button(R.string.localizable.profileAddSocial()) {

                                    }
                                    .frame(width: 160, height: 32)
                                    .font(.regular(15))
                                    .foreground(.blue())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 61)
                                            .stroke(Color(.blue()), lineWidth: 1)
                                    )

                                    Text(viewModel.profile.phone)
                                }
                            }
                            .padding(.top, 27)
                            .padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(viewModel.profile.info)
                                    .font(.regular(15))
                                    .foreground(.black())
                                Text(R.string.localizable.profileSite())
                                    .font(.regular(15))
                                    .foreground(.blue())
                            }.padding(.leading, 16)

                            VStack(alignment: .center) {
                                Button(R.string.localizable.profileAdd()) {
                                }.frame(width: geometry.size.width
                                        - 32, height: 44, alignment: .center)
                                    .font(.regular(15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.blue, lineWidth: 1)
                                    )
                            }.padding(.leading, 16)

                            photosView

                            FooterView(popupSelected: $popupSelected)
                                .padding([.leading, .trailing], 16)
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
        Button(R.string.localizable.profileBuyCell()) {
            hideTabBar()
            popupSelected.toggle()
        }
        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
        .font(.regular(15))
        .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1)
        )
    }
}
