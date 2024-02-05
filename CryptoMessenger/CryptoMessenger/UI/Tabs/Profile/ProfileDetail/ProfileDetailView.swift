import SwiftUI

// MARK: - ProfileDetailView

struct ProfileDetailView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ProfileDetailViewModel
    @Binding var selectedAvatarImage: UIImage?

    // MARK: - Private Properties

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
                                    Text(viewModel.resources.profileFromGallery),
                                    action: switchImagePicker
                                ),
                                .default(
                                    Text(viewModel.resources.profileFromCamera),
                                    action: switchCameraPicker
                                )
                            ]
                )
            }
            .alert(isPresented: $showLogoutAlert) {
                return Alert(
                    title: Text(viewModel.resources.profileDetailLogoutAlertTitle),
                    message: Text(viewModel.resources.profileDetailLogoutAlertMessage),
                    primaryButton: .default(Text(viewModel.resources.profileDetailLogoutAlertApprove),
                                            action: { viewModel.send(.onLogout) }),
                    secondaryButton: .cancel(Text(viewModel.resources.profileDetailLogoutAlertCancel))
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
                Text(viewModel.resources.profileAboutUser)
                    .foregroundColor(.romanSilver)
                    .font(Font.bodyRegular17)
                    .padding(.trailing, 16)
            }
            .listRowBackground(Color.white)
            .listRowSeparator(.hidden)
            Section {
                phone()
            } header: {
                Text("НОМЕР ТЕЛЕФОНА")
                    .foregroundColor(.romanSilver)
                    .font(Font.bodyRegular17)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Section {
                ProfileDetailActionRow(
                    title: viewModel.resources.profileDetailFirstItemCell,
                    image: viewModel.resources.web
                )
                .background(.white)
                .frame(height: 22)
                .onTapGesture {
                    viewModel.send(.onSocial)
                }
            }
            Section {
                ProfileDetailActionRow(
                    title: viewModel.resources.profileDetailLogoutAlertApprove,
                    image: viewModel.resources.leave
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
        .background(Color.ghostWhite)
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
                viewModel.resources.whiteCamera
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
                .frame(width: UIScreen.main.bounds.width - 116,
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
            Text(viewModel.countryCode)
                .font(.bodyRegular17)
                .foregroundColor(.chineseBlack)
                .frame(width: 64, height: 46, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 64, height: 46, alignment: .center)
                        .foregroundColor(.white)
                }
            HStack {
                Text(viewModel.phone)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                Spacer()
                viewModel.resources.approveBlue
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .frame(width: UIScreen.main.bounds.width - 64 - 40 - 32,
                   height: 46)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: UIScreen.main.bounds.width - 64 - 40,
                           height: 46)
                    .foregroundColor(.white)
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
            Text(viewModel.resources.tabProfile, [
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
                Text(viewModel.resources.profileDetailRightButton)
                    .font(.bodySemibold17)
                    .foregroundColor(.dodgerBlue)
            }).disabled(isSaving)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                viewModel.resources.backImage
            }
        }
    }
}
