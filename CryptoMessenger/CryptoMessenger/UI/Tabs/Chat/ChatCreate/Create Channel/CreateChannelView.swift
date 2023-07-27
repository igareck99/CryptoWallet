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
        NavigationView {
        content
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
                ImagePickerView(selectedImage: viewModel.selectedImage,
                                sourceType: .camera)
                .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                             content: {
                ImagePickerView(selectedImage: viewModel.selectedImage)
                    .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                    .navigationBarTitleDisplayMode(.inline)
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                createToolBar()
            }
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
                            R.image.profileDetail.camera.image
                                .frame(width: 26,
                                       height: 21)
                        }
                        .onTapGesture {
                            showActionImageAlert = true
                        }
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color(.blue()))
                                .frame(width: 60, height: 60)
                            R.image.profileDetail.camera.image
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
                        .background(.paleBlue())
                        .cornerRadius(8)
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)
                infoView
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                Divider()
                    .foreground(.grayE6EAED())
                    .padding(.top, 24)
                Text("тип канала".uppercased())
                    .font(.system(size: 12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                publicChannelView()
                    .padding(.top, 8)
                Divider()
                    .foreground(.grayE6EAED())
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
                .background(.paleBlue())
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            Text("Можете указать дополнительное описание вашего канала.")
                .font(.system(size: 12))
                .foreground(.darkGray())
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
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text("Создать канал")
                .font(.system(size: 17, weight: .semibold))
                .foreground(.black())
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.onChannelCreate()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(viewModel.isCreateButtonEnabled() ? .azureRadianceApprox : .gray)
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
