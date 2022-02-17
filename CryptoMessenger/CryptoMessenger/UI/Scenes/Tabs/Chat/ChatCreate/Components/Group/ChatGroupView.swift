import SwiftUI
import UIKit

// MARK: - ChatGroupView

struct ChatGroupView: View {

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var title = ""
    @State private var description = ""
    @State private var titleHeight = CGFloat(0)
    @State private var descriptionHeight = CGFloat(0)
    @State private var showPhotoLibrary = false
    @State private var selectedImage: UIImage?
    @State private var showNewChat = false

    // MARK: - Life Cycle

    init() {
        UITextView.appearance().background(.paleBlue())
    }

    // MARK: - Body

    var body: some View {
        content
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePickerView(selectedImage: $selectedImage, onSelectImage: nil)
                    .ignoresSafeArea()
                    .navigationBarTitle(Text("Фото"))
                    .navigationBarTitleDisplayMode(.inline)
            }
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
                        showNewChat.toggle()
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(title.isEmpty ? .darkGray() : .blue())
                    })
                        .disabled(title.isEmpty)
                        .background(
                            EmptyNavigationLink(destination: Text("Новый чат"), isActive: $showNewChat)
                        )
                }
            }
    }

    private var content: some View {
        ZStack {
            Color(.white()).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        showPhotoLibrary.toggle()
                    } label: {
                        if let image = selectedImage {
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
                        TextField("", text: $title)
                            .frame(height: 44)
                            .background(.paleBlue())
                            .padding(.horizontal, 16)

                        if title.isEmpty {
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
                    TextEditor(text: $description)
                        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 132, alignment: .leading)
                        .padding(.horizontal, 16)

                    if description.isEmpty {
                        Text("Описание")
                            .foreground(.darkGray())
                            .padding(.top, 12)
                            .padding(.horizontal, 16)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
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

                Spacer()
            }
        }
    }
}
