import SwiftUI
import UIKit

// MARK: - ChatGroupView

struct ChatGroupView: View {

    // MARK: - Internal Properties

    @Binding var chatData: ChatData
    @Binding var groupCreated: Bool

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var titleHeight = CGFloat(0)
    @State private var descriptionHeight = CGFloat(0)
    @State private var showPhotoLibrary = false

    // MARK: - Life Cycle

    init(chatData: Binding<ChatData>, groupCreated: Binding<Bool>) {
        self._chatData = chatData
        self._groupCreated = groupCreated
        UITextView.appearance().background(.paleBlue())
    }

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
                        groupCreated.toggle()
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(chatData.title.isEmpty ? .darkGray() : .blue())
                    })
                        .disabled(chatData.title.isEmpty)
                }
            }
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePickerView(selectedImage: $chatData.image)
                    .ignoresSafeArea()
                    .navigationBarTitle(Text("Фото"))
                    .navigationBarTitleDisplayMode(.inline)
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
                        if let image = chatData.image {
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
                        TextField("", text: $chatData.title)
                            .frame(height: 44)
                            .background(.paleBlue())
                            .padding(.horizontal, 16)

                        if chatData.title.isEmpty {
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
                    TextEditor(text: $chatData.description)
                        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 132, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    if chatData.description.isEmpty {
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

                if groupCreated {
                    ZStack {
                        ProgressView()
                            .tint(Color(.blue()))
                    }
                }

                Spacer()
            }
        }
    }
}
