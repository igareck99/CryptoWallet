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

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            R.image.navigation.backButton.image
                        })
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Название группы")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(viewModel.resources.titleColor)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.createChat()
                        }, label: {
                            Text("Готово")
                                .font(.system(size: 15, weight: .semibold))
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
                .fullScreenCover(isPresented: $showCameraPicker,
                                 content: {
                    ImagePickerView(selectedImage: $viewModel.chatData.image,
                                    sourceType: .camera)
                    .ignoresSafeArea()
                })
                .fullScreenCover(isPresented: $showImagePicker,
                                 content: {
                    ImagePickerView(selectedImage: $viewModel.chatData.image)
                        .navigationBarTitle(Text(viewModel.resources.photoEditorTitle))
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                })
                .onAppear {
                    UITextView.appearance()
                }.background(viewModel.resources.textBoxBackground)
        }
    }

    private var content: some View {
        ZStack {
            viewModel.resources.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        showActionImageAlert.toggle()
                    } label: {
                        if let image = viewModel.chatData.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60, alignment: .center)
                                .cornerRadius(30)
                        } else {
                            RoundedRectangle(cornerRadius: 30)
                                .background(viewModel.resources.buttonBackground)
                                .cornerRadius(30)
                                .frame(width: 60, height: 60, alignment: .center)
                                .overlay(
                                    R.image.chat.group.photo.image
                                )
                        }
                    }

                    ZStack(alignment: .topLeading) {
                        TextField("", text: $viewModel.titleText)
                            .frame(height: 44)
                            .background(viewModel.resources.textBoxBackground)
                            .padding(.horizontal, 16)

                        if viewModel.titleText.isEmpty {
                            Text("Название")
                                .foregroundColor(viewModel.resources.titleColor)
                                .padding(.top, 12)
                                .padding(.horizontal, 16)
                                .disabled(true)
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(height: 44)
                    .background(viewModel.resources.textBoxBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)

                HStack(spacing: 0) {
                    Text("Информация".uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(viewModel.resources.textColor)
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    Spacer()
                }

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.descriptionText)
                        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 132, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 2)
						.scrollContentBackground(.hidden)

                    if viewModel.descriptionText.isEmpty {
                        Text("Описание")
                            .foregroundColor(viewModel.resources.textColor)
                            .padding(.top, 12)
                            .padding(.horizontal, 19)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
                .background(viewModel.resources.textBoxBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.horizontal, 16)

                HStack(spacing: 0) {
                    Text("Можете указать дополнительное описание для Вашей группы.")
                        .lineLimit(nil)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(viewModel.resources.textColor)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                    Spacer()
                }

                if viewModel.isRoomCreated {
                    ZStack {
                        ProgressView()
                            .tint(viewModel.resources.buttonBackground)
                    }
                }

                Spacer()
            }
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
