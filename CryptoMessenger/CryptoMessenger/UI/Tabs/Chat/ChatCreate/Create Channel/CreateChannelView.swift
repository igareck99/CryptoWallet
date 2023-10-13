import SwiftUI

// MARK: - CreateChannelView

struct CreateChannelView<ViewModel: CreateChannelViewModelProtocol>: View {

    // MARK: - Internal Properties

    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: ViewModel
    @FocusState private var descriptionIsFocused: Bool
    @FocusState private var channelNameIsFocused: Bool

    // MARK: - Private Properties

    @State private var showActionImageAlert = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var isPublicSelected = true
    @State private var isPrivateSelected = false
    @State private var isEncryptionEnabled = false

    // MARK: - Body

    var body: some View {
        content
            .actionSheet(isPresented: $showActionImageAlert) {
                ActionSheet(title: Text(""),
                            message: nil,
                            buttons: [
                                .cancel(),
                                .default(
                                    Text(viewModel.resources.profileFromGallery).font(.calloutRegular16),
                                    action: switchImagePicker
                                ),
                                .default(
                                    Text(viewModel.resources.profileFromCamera).font(.calloutRegular16),
                                    action: switchCameraPicker
                                )
                            ]
                )
            }
            .fullScreenCover(isPresented: $showCameraPicker,
                             content: {
                ImagePickerView(selectedImage: viewModel.selectedImage,
                                sourceType: .camera)
                .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                             content: {
                ImagePickerView(selectedImage: viewModel.selectedImage)
                    .navigationBarTitle(Text(viewModel.resources.photoEditorTitle))
                    .navigationBarTitleDisplayMode(.inline)
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                createToolBar()
            }
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.top, 16)
                HStack(alignment: .center, spacing: 12) {
                    if viewModel.selectedImg != nil {
                        ZStack {
                            Image(uiImage: viewModel.selectedImg ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60,
                                       height: 60)
                                .cornerRadius(30)
                            R.image.profileDetail.whiteCamera.image
                                .frame(width: 26,
                                       height: 21)
                        }
                        .onTapGesture {
                            showActionImageAlert = true
                        }
                    } else {
                        ZStack {
                            Circle()
                                .fill(viewModel.resources.buttonBackground)
                                .frame(width: 60, height: 60)
                            R.image.profileDetail.whiteCamera.image
                                .frame(width: 26,
                                       height: 21)
                        }
                        .onTapGesture {
                            showActionImageAlert = true
                        }
                    }
                    TextField("", text: viewModel.channelName)
                        .focused($channelNameIsFocused)
                        .placeholder(
                            "Название",
                            when: !viewModel.isCreateButtonEnabled() && !channelNameIsFocused,
                            alignment: .topLeading
                        )
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                        .frame(height: 44)
                        .background(viewModel.resources.textBoxBackground)
                        .cornerRadius(8)
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)
                infoView
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                Divider()
                    .foregroundColor(viewModel.resources.dividerColor)
                    .padding(.top, 24)
                Text(viewModel.resources.createChannelChannelType.uppercased())
                    .font(.caption1Regular12)
                    .foregroundColor(viewModel.resources.textColor)
                    .padding(.leading, 16)
                publicChannelView()
                    .padding(.top, 8)
                Divider()
                    .foregroundColor(viewModel.resources.dividerColor)
                    .padding(.top, 8)
                    .padding(.leading, 16)
                privateChannelView()
                    .padding(.top, 8)
                if isPrivateSelected {
                    encrytionView()
                        .padding(.top, 4)
                        .padding(.bottom, 16)
                }
                Spacer()
            }
        }
    }

    // MARK: - Private Methods

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextEditor(text: viewModel.channelDescription)
                .focused($descriptionIsFocused)
                .placeholder(
                    "Описание",
                    when: !viewModel.isDescriptionPlaceholderEnabled() && !descriptionIsFocused,
                    alignment: .topLeading
                )
                .padding(.horizontal, 14)
                .padding(.top, 6)
                .scrollContentBackground(.hidden)
                .frame(height: 132)
                .background(viewModel.resources.textBoxBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            Text(viewModel.resources.createChannelDescription)
                .font(.caption1Regular12)
                .foregroundColor(viewModel.resources.textColor)
                .padding(.top, 6)
        }
    }

    private func publicChannelView() -> some View {
        ChannelTypeView(
            title: "Публичный канал",
            text: "Публичные каналы можно найти через поиск, подписаться на них может любой пользователь.",
            channelType: .publicChannel,
            isSelected: $isPublicSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            viewModel.channelType = channelType
            isPrivateSelected = false
        }
        .padding(.horizontal, 16)
    }

    private func privateChannelView() -> some View {
        ChannelTypeView(
            title: "Частный канал",
            text: "На частные каналы можно подписаться только по ссылке-приглашению.",
            channelType: .privateChannel,
            isSelected: $isPrivateSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            viewModel.channelType = channelType
            isPublicSelected = false
        }
        .padding(.horizontal, 16)
    }

    private func encrytionView() -> some View {
        EncryptionStateView(
            title: "Шифрование",
            text: "Обратите внимание, что если вы включите шифрование, в дальнейшем его нельзя будет отключить",
            isEncrypted: $isEncryptionEnabled
        )
        .padding(.horizontal, 16)
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                viewModel.resources.backButtonImage
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.createActionCreateChannel)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.onChannelCreate()
            }, label: {
                Text(viewModel.resources.profileDetailRightButton)
                    .font(.bodySemibold17)
                    .foregroundColor(viewModel.isCreateButtonEnabled() ? viewModel.resources.buttonBackground : viewModel.resources.textColor)
            })
            .disabled(!viewModel.isCreateButtonEnabled())
        }
    }

    private func switchImagePicker() {
        showImagePicker = true
    }

    private func switchCameraPicker() {
        showCameraPicker = true
    }
}
