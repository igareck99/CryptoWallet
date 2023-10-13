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
                .frame(width: UIScreen.main.bounds.width - 32)
            VStack(alignment: .leading,
                   spacing: 10) {
                Text(R.string.localizable.profileAboutUser())
                    .foregroundColor(.romanSilver)
                    .font(.calloutRegular16)
                TextEditor(text: $viewModel.profile.status)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    .background(Color.white)
                    .placeholder(R.string.localizable.createChannelDescription(),
                                 when: viewModel.profile.status.isEmpty)
                    .foregroundColor(.chineseBlack)
                    .font(.bodyRegular17)
                    .frame(height: 134)
                    .cornerRadius(8)
            }
                   .listRowBackground(Color.clear)
                   .listRowSeparator(.hidden)
                   .frame(width: UIScreen.main.bounds.width - 32)
            Section {
                ProfileDetailActionRow(
                    title: R.string.localizable.profileDetailFirstItemCell(),
                    image: R.image.profileDetail.socialNetwork.image
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
                    image: R.image.profileDetail.exit.image
                )
                .background(.white)
                .frame(height: 22)
                .onTapGesture {
                    vibrate()
                    showLogoutAlert.toggle()
                }
            }
        }.listStyle(.insetGrouped)
    }

//    var content: some View {
//        ZStack {
//            List {
//                ForEach(0..<ProfileDetailType.allCases.count, id: \.self) { index in
//                    let type = ProfileDetailType.allCases[index]
//                    switch type {
//                    case .avatar:
//                        mainView
//                            .padding(.horizontal, 16)
//                            .frame(height: 64)
//                    case .status:
//                        TextFieldView(
//                            title: type.title.uppercased(),
//                            text: $viewModel.profile.status,
//                            placeholder: type.title
//                        )
//                        .padding(.top, 24)
//                        .padding([.leading, .trailing], 16)
//                    case .phone:
//                        phone(type.title.uppercased())
//                            .padding(.top, 24)
//                            .padding([.leading, .trailing], 16)
//                    case .socialNetwork:
//                        ProfileDetailActionRow(
//                            title: "Ваши социальные сети",
//                            color: .white,
//                            image: R.image.profileDetail.socialNetwork.image
//                        )
//                        .onTapGesture {
//                            viewModel.send(.onSocial)
//                        }
//                        .background(.white)
//                        .frame(height: 64)
//                        .padding(.top, 24)
//                        .padding([.leading, .trailing], 16)
//                    case .exit:
//                        ProfileDetailActionRow(
//                            title: "Выход",
//                            color: .white,
//                            image: R.image.profileDetail.exit.image
//                        )
//                        .background(.white)
//                        .frame(height: 64)
//                        .padding(.top, 16)
//                        .padding([.leading, .trailing], 16)
//                        .onTapGesture {
//                            vibrate()
//                            showLogoutAlert.toggle()
//                        }
//                    }
//                }
//            }
//            .listStyle(.insetGrouped)
//
//            if isSaving {
//                ZStack {
//                    ProgressView()
//                        .tint(.dodgerBlue)
//                        .frame(width: 12, height: 12)
//                }
//            }
//        }
//        .background(isSaving ? Color.chineseBlackLoad : .ghostWhite)
//        .ignoresSafeArea()
//    }
    
    private var avatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let img = viewModel.selectedImg {
                Image(uiImage: img)
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .cornerRadius(34)
            } else if let url = viewModel.profile.avatar {
                AsyncImage(
                    defaultUrl: url,
                    placeholder: {
                        ZStack {
                            ProgressView()
                                .tint(.dodgerBlue)
                                .frame(width: 34,
                                       height: 34)
                                .background(Color.dodgerTransBlue)
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
                    .foregroundColor(.dodgerTransBlue)
                    .frame(width: 24, height: 24)
                R.image.profileDetail.whiteCamera.image
                    .resizable()
                    .frame(width: 10.5, height: 8.2)
            }
        }
    }
    
    private var mainView: some View {
        HStack(alignment: .center, spacing: 8) {
            avatarView
            TextField("", text: $viewModel.profile.name)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                .foregroundColor(.chineseBlack)
                .frame(height: 46)
                .font(.subheadlineRegular15)
                .background(Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                )
        }
    }

    private func info(_ title: String) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title.uppercased(), [
                    .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left))
                ]).font(.caption1Medium12)
                    .frame(height: 22)
                    .foregroundColor(.romanSilver)
                ZStack(alignment: .leading) {
                    if viewModel.profile.info.isEmpty {
                        Text(title.firstUppercased)
                            .foregroundColor(.romanSilver07)
                            .font(.subheadlineRegular15)
                            .padding([.leading, .trailing], 16)
                    }

                    TextEditor(text: $viewModel.profile.info)
                        .foregroundColor(.chineseBlack)
                        .font(.subheadlineRegular15)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 140)
                        .padding([.leading, .trailing], 14)
                }
                .background(.white)
                .cornerRadius(8)
            }
        }

    private func phone(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title, [
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left))
            ]).font(.caption1Regular12)
                .frame(height: 22)
                .foregroundColor(.romanSilver)
            HStack(spacing: 0) {
                Text(R.string.localizable.profileDetailPhoneExample())
                    .foregroundColor(.chineseBlack)
                    .frame(height: 44)
                    .font(.subheadlineRegular15)
                    .padding(.leading, 16)
                Spacer()
                R.image.profileDetail.arrow.image
                    .padding(.trailing, 16)
            }
            .background(.white)
            .cornerRadius(8)

            HStack(spacing: 0) {
                Text(viewModel.profile.phone)
                    .foregroundColor(.chineseBlack)
                    .frame(height: 44)
                    .font(.subheadlineRegular15)
                    .padding(.leading, 16)
                Spacer()
            }
            .background(.white)
            .cornerRadius(8)
        }
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
    }
}
