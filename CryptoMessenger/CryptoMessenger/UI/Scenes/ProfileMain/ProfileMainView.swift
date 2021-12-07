import SwiftUI

// MARK: - ProfileMainView

struct ProfileMainView: View {

    // MARK: - Internal Properties

    var profile: ProfileUserItem

    // MARK: - Private Properties

    @State private var popupSelected = false
    @State private var showMenu = false
    private let gridItems = Array(repeating: GridItem(), count: 3)

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(popupSelected ? [] : .vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 16) {
                                Image(uiImage: profile.image ?? UIImage())
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)

                                VStack(alignment: .leading, spacing: 11) {
                                    Text(profile.name).font(.medium(15))

                                    Button(R.string.localizable.profileAdd()) {

                                    }.frame(width: 160, height: 32)
                                        .font(.regular(15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 61)
                                                .stroke(.blue, lineWidth: 1)
                                        )
                                    Text(profile.number)
                                }
                            }.padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(profile.info)
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

                            LazyVGrid(columns: gridItems, alignment: .center, spacing: 1.5) {
                                ForEach(0..<profile.photos.count, id: \.self) { number in
                                    VStack {
                                        Image(uiImage: profile.photos[number] ?? UIImage())
                                            .resizable()
                                            .frame(width: (geometry.size.width - 3) / 3,
                                                   height: (geometry.size.width - 3) / 3, alignment: .center)
                                            .scaledToFit()
                                    }
                                }
                            }

                            FooterView(popupSelected: $popupSelected)
                                .padding([.leading, .trailing], 16)
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Text(profile.nickname)
                                    .font(.bold(15))
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Image(uiImage: R.image
                                        .profile.settings() ?? UIImage())
                                    .onTapGesture {
                                        showMenu = true
                                    }
                            }
                        }
                }
            }
            .popup(
                isPresented: $showMenu,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: Color(.gray(0.9)),
                dismissCallback: { showTabBar() },
                view: {
                    ProfileMainAdditional(balance: "0.50", cells: ProfileMainMenuItem.getmenuItems())
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
                backgroundColor: Color(.gray(0.9)),
                dismissCallback: { showTabBar() },
                view: {
                    BuyCellView()
                        .frame(height: 375, alignment: .center)
                        .background(
                            CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                                .fill(Color(.white()))
                        )
                }
            )
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

// MARK: - ProfileMainView_Preview

struct ProfileMainViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileMainView(profile: ProfileUserItem.getProfile())
    }
}
