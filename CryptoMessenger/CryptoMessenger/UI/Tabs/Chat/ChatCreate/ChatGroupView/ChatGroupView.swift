import SwiftUI
import UIKit

// MARK: - ChatGroupView

struct ChatGroupView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatGroupViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var titleHeight = CGFloat(0)
    @State private var descriptionHeight = CGFloat(0)
    @State private var showActionImageAlert = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var showLocationPicker = false
    @State private var bottomPadding: CGFloat = 0

    // MARK: - Body

    var body: some View {
        content
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .hideKeyboardOnTap()
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .popup(
                isPresented: viewModel.isSnackbarPresented,
                alignment: .bottom
            ) {
                Snackbar(
                    text: viewModel.snackBarText,
                    color: viewModel.shackBarColor
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        R.image.navigation.backButton.image
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text(viewModel.navBarTitle)
                        .font(.bodySemibold17)
                        .foregroundColor(viewModel.resources.titleColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.onCreate()
                    }, label: {
                        Text(viewModel.resources.profileDetailRightButton)
                            .font(.bodyRegular17)
                            .foregroundColor(viewModel.titleText.isEmpty ? viewModel.resources.textColor : viewModel.resources.buttonBackground)
                    })
                    .disabled(viewModel.titleText.isEmpty)
                }
            }
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
                ImagePickerView(selectedImage: $viewModel.chatData.image,
                                sourceType: .camera)
                .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                             content: {
                ImagePickerView(selectedImage: $viewModel.selectedImg)
                    .navigationBarTitle(Text(viewModel.resources.photoEditorTitle))
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            })
    }

    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(spacing: 16) {
                Button {
                    showActionImageAlert.toggle()
                } label: {
                    if let image = viewModel.selectedImg {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 68, height: 68, alignment: .center)
                            .cornerRadius(34)
                    } else {
                        RoundedRectangle(cornerRadius: 30)
                            .background(viewModel.resources.buttonBackground)
                            .cornerRadius(34)
                            .frame(width: 68, height: 68, alignment: .center)
                            .overlay(
                                R.image.chat.group.photo.image
                            )
                    }
                }
                TextField("Название", text: $viewModel.titleText)
                    .textFieldStyle(OvalTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            VStack(alignment: .leading, spacing: 0) {
                TextEditorWithPlaceholder(text: $viewModel.descriptionText,
                                          placeholder: "Описание")
                    .frame(maxWidth: .infinity, idealHeight: 134, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                HStack(spacing: 0) {
                    Text(viewModel.textEditorDescription)
                        .lineLimit(nil)
                        .font(.caption1Regular12)
                        .foregroundColor(.manatee)
                        .padding(.leading, 22)
                    Spacer()
                }
            }
            Divider()
                .frame(height: 0.5)
                .padding(.top, 24)
            VStack(alignment: .leading) {
                Text("тип канала".uppercased())
                    .font(.caption1Regular12)
                    .padding(.leading, 15)
                    .foreground(.romanSilver)
                if viewModel.type == .channel {
                    channelSettingsView
                } else {
                    encrytionView
                }
            }
            .padding(.top, 16.5)
            Spacer()
        }
    }

    // MARK: - Private Methods

    private func switchImagePicker() {
        showImagePicker = true
    }

    private func switchCameraPicker() {
        showCameraPicker = true
    }

    private var channelSettingsView: some View {
        VStack {
            publicChannelView()
                .padding(.top, 8)
            Divider()
                .padding(.top, 9)
            privateChannelView()
                .padding(.top, 8)
            if viewModel.channelType == .privateChannel {
                encrytionView
                    .padding(.top, 8)
            }
        }
    }
    
    private var encrytionView: some View {
        EncryptionStateView(
            title: "Шифрование",
            text: "Обратите внимание, что если вы включите шифрование, в дальнейшем его нельзя будет отключить",
            isEncrypted: $viewModel.isEncryptionEnable
        )
        .padding(.horizontal, 16)
    }
    
    private func publicChannelView() -> some View {
        ChannelTypeView(
            title: "Публичный канал",
            text: "Публичные каналы можно найти через поиск, подписаться на них может любой пользователь.",
            channelType: .publicChannel,
            isSelected: $viewModel.isPublicSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.channelType = channelType
                viewModel.isPrivateSelected = false
            }
        }
        .padding(.horizontal, 16)
    }

    private func privateChannelView() -> some View {
        ChannelTypeView(
            title: "Частный канал",
            text: "На частные каналы можно подписаться только по ссылке-приглашению.",
            channelType: .privateChannel,
            isSelected: $viewModel.isPrivateSelected
        ) { channelType in
            debugPrint("Channel type seledted: \(channelType)")
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.channelType = channelType
                viewModel.isPublicSelected = false
            }
        }
        .padding(.horizontal, 16)
    }
}
