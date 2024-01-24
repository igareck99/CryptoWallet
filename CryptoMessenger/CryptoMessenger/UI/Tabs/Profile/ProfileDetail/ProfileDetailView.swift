import SwiftUI

// MARK: - ProfileDetailView

struct ProfileDetailView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileDetailViewModel
    @Binding var selectedAvatarImage: UIImage?

    // MARK: - Private Properties

    @State private var descriptionHeight = CGFloat(100)
    @State private var showLogoutAlert = false
    @State private var showActionImageAlert = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var isSaving = false
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Body
    
    var body: some View {
        content
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .hideKeyboardOnTap()
            .onReceive(viewModel.$closeScreen) { closed in
                if closed {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toolbar {
                createToolBar()
            }
            .onChange(of: viewModel.selectedImg, perform: { newValue in
                guard let image = newValue else { return }
                selectedAvatarImage = image
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
            .alert(isPresented: $showLogoutAlert) {
                return Alert(
                    title: Text(R.string.localizable.profileDetailLogoutAlertTitle()),
                    message: Text(R.string.localizable.profileDetailLogoutAlertMessage()),
                    primaryButton: .default(Text(R.string.localizable.profileDetailLogoutAlertApprove()),
                                            action: { viewModel.send(.onLogout) }),
                    secondaryButton: .cancel(Text(R.string.localizable.profileDetailLogoutAlertCancel()))
                )
            }
            .toolbar(.hidden, for: .tabBar)
            .onDisappear {
                viewModel.closeScreen = false
            }
    }
    
    private var content: some View {
        List {
            mainView
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            Section {
                TextEditor(text: $viewModel.profile.status)
                    .placeholder(when: viewModel.profile.status.isEmpty,
                                 alignment: .topLeading, placeholder: {
                        Text("Описание")
                            .foreground(.romanSilver07)
                            .font(.bodyRegular17)
                            .padding(.top, 8)
                            .padding(.leading, 3)
                    })
                    .background(.white)
                    .foregroundColor(Color.chineseBlack)
                    .font(.bodyRegular17)
                    .frame(height: 134 - 22)
            } header: {
                Text(R.string.localizable.profileAboutUser())
                    .foregroundColor(.romanSilver)
                    .font(Font.bodyRegular17)
                    .padding(.trailing, 16)
            }
            .listRowBackground(Color.white)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading,
                   spacing: 6) {
                Text("НОМЕР ТЕЛЕФОНА")
                    .foregroundColor(.romanSilver)
                    .font(Font.bodyRegular17)
                    .padding(.leading, 4)
                phone()
            }
                   .listRowBackground(Color.clear)
                   .listRowSeparator(.hidden)
                   .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Section {
                ProfileDetailActionRow(
                    title: R.string.localizable.profileDetailFirstItemCell(),
                    image: R.image.profileDetail.web.image
                )
                .background(.white)
                .frame(height: 22)
                .onTapGesture {
                    viewModel.send(.onSocial)
                }
            }
            Section {
                ProfileDetailActionRow(
                    title: R.string.localizable.profileDetailLogoutAlertApprove(),
                    image: R.image.profileDetail.leave.image
                )
                .background(.white)
                .frame(height: 22)
                .onTapGesture {
                    vibrate()
                    showLogoutAlert.toggle()
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.ghostWhite.edgesIgnoringSafeArea(.all))
    }
    
    private var avatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let img = viewModel.selectedImg {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .cornerRadius(34)
            } else if let url = viewModel.profile.avatar {
                AsyncImage(
                    defaultUrl: url,
                    placeholder: {
                        ZStack {
                            Circle()
                                .foregroundColor(.diamond)
                                .frame(width: 68, height: 68)
                            Text(viewModel.profile.name.firstLetter.uppercased())
                                .foregroundColor(.white)
                                .font(.title1Bold28)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 68, height: 68)
                .cornerRadius(34)
            }
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(.dodgerBlue)
                    .frame(width: 24, height: 24)
                R.image.profileDetail.whiteCamera.image
                    .resizable()
                    .frame(width: 10.5, height: 8.2)
                    .onTapGesture {showActionImageAlert.toggle()}
            }
        }
    }
    
    private var mainView: some View {
        HStack(alignment: .center) {
            avatarView
            TextField("", text: $viewModel.profile.name)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                .foregroundColor(.chineseBlack)
                .frame(width: UIScreen.main.bounds.width - 68 - 16 - 16 - 16,
                       height: 46)
                .font(.bodyRegular17)
                .textFieldStyle(.plain)
                .background(content: {
                    Color.white
                })
                .cornerRadius(radius: 8, corners: .allCorners)
        }
    }
    
    @ViewBuilder
    private func phone() -> some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 64, height: 46, alignment: .center)
                    .background(.white())
                    .foregroundColor(.white)
                Text(viewModel.countryCode)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: UIScreen.main.bounds.width - 64 - 40,
                           height: 46)
                    .background(.white())
                    .foregroundColor(.white)
                HStack {
                    Text(viewModel.phone)
                        .font(.bodyRegular17)
                        .foregroundColor(.chineseBlack)
                    Spacer()
                    R.image.profileDetail.approveBlue.image
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Private Methods

    private func switchImagePicker() {
        viewModel.send(.onGallery(.photoLibrary))
    }

    private func switchCameraPicker() {
        viewModel.send(.onGallery(.camera))
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(R.string.localizable.tabProfile(), [
                .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
            ])
            .font(.bodySemibold17)
            .foregroundColor(.chineseBlack)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                isSaving.toggle()
                viewModel.send(.onDone)
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.bodySemibold17)
                    .foregroundColor(.dodgerBlue)
            }).disabled(isSaving)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                R.image.navigation.backButton.image
            }
        }
    }
}
