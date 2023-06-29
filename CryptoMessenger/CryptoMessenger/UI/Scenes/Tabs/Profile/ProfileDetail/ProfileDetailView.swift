import SwiftUI

// MARK: - ProfileDetailView

struct ProfileDetailView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: ProfileDetailViewModel
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Профиль", [
                        .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                    ])
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.chineseBlack)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSaving.toggle()
                        viewModel.send(.onDone)
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foregroundColor(.dodgerBlue)
                    }).disabled(isSaving)
                }
            }
            .hideKeyboardOnTap()
            .onReceive(viewModel.$closeScreen) { closed in
                if closed {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onReceive(viewModel.$selectedImage, perform: { value in
                guard let image = value else { return }
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
            .alert(isPresented: $showLogoutAlert) {
                return Alert(
                    title: Text(R.string.localizable.profileDetailLogoutAlertTitle()),
                    message: Text(R.string.localizable.profileDetailLogoutAlertMessage()),
                    primaryButton: .default(Text(R.string.localizable.profileDetailLogoutAlertApprove()),
                                            action: { viewModel.send(.onLogout) }),
                    secondaryButton: .cancel(Text(R.string.localizable.profileDetailLogoutAlertCancel()))
                )
            }
            .onAppear {
                hideTabBar()
                // Оставил для информации по логике отображения нав бара
//                showNavBar()
            }
            .onDisappear {
                viewModel.closeScreen = false
                showTabBar()
            }
    }

    var content: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(0..<ProfileDetailType.allCases.count, id: \.self) { index in
                            let type = ProfileDetailType.allCases[index]
                            switch type {
                            case .avatar:
                                avatarView.frame(height: geometry.size.width)
                            case .status:
                                TextFieldView(
                                    title: type.title.uppercased(),
                                    text: $viewModel.profile.status,
                                    placeholder: type.title
                                )
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .name:
                                TextFieldView(
                                    title: type.title.uppercased(),
                                    text: $viewModel.profile.name,
                                    placeholder: type.title
                                )
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .phone:
                                phone(type.title.uppercased())
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .socialNetwork:
                                ProfileDetailActionRow(
                                    title: "Ваши социальные сети",
                                    color: .white,
                                    image: R.image.profileDetail.socialNetwork.image
                                )
                                    .onTapGesture {
                                        viewModel.send(.onSocial)
                                    }
                                    .background(.white)
                                    .frame(height: 64)
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing], 16)
                            case .exit:
                                Divider()
                                    .foregroundColor(.brightGray)
                                    .padding(.top, 16)
                                ProfileDetailActionRow(
                                    title: "Выход",
                                    color: .white,
                                    image: R.image.profileDetail.exit.image
                                )
                                    .background(.white)
                                    .frame(height: 64)
                                    .padding(.top, 16)
                                    .padding([.leading, .trailing], 16)
                                    .onTapGesture {
                                        vibrate()
                                        showLogoutAlert.toggle()
                                    }
                            case .delete:
                                ProfileDetailActionRow(
                                    title: "Удалить учетную запись",
                                    color: .white,
                                    image: R.image.profileDetail.delete.image
                                )
                                    .background(.white)
                                    .frame(height: 64)
                                    .padding([.leading, .trailing], 16)
                            }
                        }
                    }
                }
            }

            if isSaving {
                ZStack {
                    ProgressView()
                        .tint(.dodgerBlue)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .background(isSaving ? Color.chineseBlackLoad : .ghostWhite)
        .ignoresSafeArea()
    }

    private var avatarView: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                } else if let url = viewModel.profile.avatar {
                    AsyncImage(
                        defaultUrl: url,
                        placeholder: {
                            ZStack {
                                ProgressView()
                                    .tint(.dodgerBlue)
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.width)
                                    .background(Color.dodgerTransBlue)
                            }
                        },
                        result: {
                            Image(uiImage: $0).resizable()
                        }
                    )
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                } else {
                    ZStack {
                        Rectangle()
                            .frame(height: geometry.size.width)
                            .foregroundColor(.dodgerTransBlue)
                        R.image.profile.avatarThumbnail.image
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
                ZStack {
                    VStack(spacing: 0) {
                        Spacer()
                        HStack(spacing: 0) {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.chineseBlack04)
                                    .frame(width: 60, height: 60)
                                R.image.profileDetail.camera.image
                            }
                            .onTapGesture {
                                showActionImageAlert = true
                            }
                            .padding([.trailing, .bottom], 16)
                        }
                    }
                }
            }
        }
    }

    private func info(_ title: String) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title.uppercased(), [
                    .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left))
                ]).font(.system(size: 12, weight: .semibold))
                    .frame(height: 22)
                    .foregroundColor(.romanSilver)
                ZStack(alignment: .leading) {
                    if viewModel.profile.info.isEmpty {
                        Text(title.firstUppercased)
                            .foregroundColor(.romanSilver07)
                            .font(.regular(15))
                            .padding([.leading, .trailing], 16)
                    }

                    TextEditor(text: $viewModel.profile.info)
                        .foregroundColor(.chineseBlack)
                        .font(.regular(15))
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
            ]).font(.system(size: 12, weight: .semibold))
                .frame(height: 22)
                .foregroundColor(.romanSilver)
            HStack(spacing: 0) {
                Text("+7   Россия")
                    .foregroundColor(.chineseBlack)
                    .frame(height: 44)
                    .font(.regular(15))
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
                    .font(.regular(15))
                    .padding(.leading, 16)
                Spacer()
            }
            .background(.white)
            .cornerRadius(8)
        }
    }

    // MARK: - Private Methods

    private func switchImagePicker() {
        showImagePicker = true
    }

    private func switchCameraPicker() {
        showCameraPicker = true
    }
}
