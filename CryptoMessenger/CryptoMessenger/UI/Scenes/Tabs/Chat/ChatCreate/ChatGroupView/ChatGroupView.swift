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
                        .font(.bold(15))
                        .foreground(.black())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.createChat()
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(viewModel.titleText.isEmpty ? .darkGray() : .blue())
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
                ImagePickerView(selectedImage: $viewModel.chatData.image,
                                sourceType: .camera)
                    .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                              content: {
                ImagePickerView(selectedImage: $viewModel.chatData.image)
                    .navigationBarTitle(Text(R.string.localizable.photoEditorTitle()))
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            })
            .onAppear {
                UITextView.appearance().background(.paleBlue())
            }
    }

    private var content: some View {
        ZStack {
            Color(.white()).ignoresSafeArea()

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
                                .background(.blue())
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
                            .background(.paleBlue())
                            .padding(.horizontal, 16)

                        if viewModel.titleText.isEmpty {
                            Text("Название")
                                .foreground(.darkGray())
                                .padding(.top, 12)
                                .padding(.horizontal, 16)
                                .disabled(true)
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(height: 44)
                    .background(.paleBlue())
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)

                HStack(spacing: 0) {
                    Text("Информация".uppercased())
                        .font(.semibold(12))
                        .foreground(.darkGray())
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
                            .foreground(.darkGray())
                            .padding(.top, 12)
                            .padding(.horizontal, 19)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
                .background(.paleBlue())
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.horizontal, 16)

                HStack(spacing: 0) {
                    Text("Можете указать дополнительное описание для Вашей группы.")
                        .lineLimit(nil)
                        .font(.regular(12))
                        .foreground(.darkGray())
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                    Spacer()
                }

                if viewModel.isRoomCreated {
                    ZStack {
                        ProgressView()
                            .tint(Color(.blue()))
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
