import SwiftUI

// MARK: - ProfileMainView

struct ProfileMainView: View {

    // MARK: - Internal Properties

    @State var showingPopup = false
    var profile: ProfileUserItem

    // MARK: - Private Properties

    var gridItems = [GridItem](repeating: GridItem(), count: 3)

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 16) {
                            Image(uiImage: profile.image ?? UIImage())
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                            VStack(alignment: .leading, spacing: 11) {
                                Text(profile.name)
                                    .font(.medium(15))
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
                            ForEach((0..<profile.photos.count), id: \.self) { number in
                                VStack {
                                    Image(uiImage: profile.photos[number] ?? UIImage())
                                        .resizable()
                                        .frame(width: (geometry.size.width - 3) / 3,
                                               height: (geometry.size.width - 3) / 3, alignment: .center)
                                        .scaledToFit()
                                }
                            }
                        }
                        FooterView(showingPopup: showingPopup).padding(.leading, 16)
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
                        }
                    }
                }
            }
        }.popup(isPresented: $showingPopup,
                type: .toast,
                position: .bottom,
                closeOnTap: true,
                closeOnTapOutside: true,
                backgroundColor: Color(.black(0.9))) {
            BuyCellView(showingPopup: true)
                .padding(.leading, -16)
                .frame(width: geometry.size.width,
                       height: 375,
                       alignment: .center)
                .cornerRadius(16)
        }

        }
    }
}

// MARK: - FooterView

struct FooterView: View {

    // MARK: - Internal Properties

    @State var showingPopup: Bool

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            Button(R.string.localizable.profileBuyCell()) {
                showingPopup.toggle()
                print(showingPopup)
            }.frame(width: geometry.size.width
                    - 16, height: 44, alignment: .center)
                .font(.regular(15))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                ).popup(isPresented: $showingPopup,
                        type: .toast,
                        position: .bottom,
                        closeOnTap: true,
                        closeOnTapOutside: true,
                        backgroundColor: Color(.black(0.9))) {
                    BuyCellView(showingPopup: showingPopup)
                        .frame(width: geometry.size.width,
                               height: 375,
                               alignment: .center)
                        .cornerRadius(16)
                }
        }
    }
}

// MARK: - ProfileMainView_Preview

struct ProfileMainViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileMainView(profile: ProfileUserItem.getProfile())
    }
}
