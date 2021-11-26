import SwiftUI
import UIKit

// MARK: - ChatGroupView

struct ChatGroupView: View {

    @Environment(\.presentationMode) private var presentationMode
    @State private var title = ""
    @State private var description = ""
    @State private var titleHeight = CGFloat(0)
    @State private var descriptionHeight = CGFloat(0)
    @State private var showPhotoLibrary = false
    @State private var selectedImage: UIImage?
    @State private var isActive = false

    private var titleFieldHeight: CGFloat {
        let minHeight: CGFloat = 44
        let maxHeight: CGFloat = 44

        if titleHeight < minHeight {
            return minHeight
        }

        if titleHeight > maxHeight {
            return maxHeight
        }

        return titleHeight
    }

    private var descriptionFieldHeight: CGFloat {
        let minHeight: CGFloat = 44
        let maxHeight: CGFloat = 132

        if descriptionHeight < minHeight {
            return minHeight
        }

        if descriptionHeight > maxHeight {
            return maxHeight
        }

        return descriptionHeight
    }

    // MARK: - Body

    var body: some View {
        content
            .sheet(isPresented: $showPhotoLibrary) {
                NavigationView {
                    ImagePickerView(selectedImage: $selectedImage)
                    .ignoresSafeArea()
                    .navigationBarTitle(Text("Фото"))
                    .navigationBarTitleDisplayMode(.inline)
                }
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
                        isActive.toggle()
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(title.isEmpty ? .darkGray() : .blue())
                    })
                        .disabled(title.isEmpty)
                        .background(
                            EmptyNavigationLink(
                                destination: Text("Новый чат"),
                                isActive: $isActive
                            )
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
                        DynamicHeightTextField(text: $title, height: $titleHeight)
                            .background(.paleBlue())

                        if title.isEmpty {
                            Text("Название")
                                .foreground(.darkGray())
                                .padding(.top, 12)
                                .padding([.leading, .trailing], 19)
                                .disabled(true)
                                .allowsHitTesting(false)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .frame(height: titleFieldHeight)
                }
                .padding([.leading, .trailing], 16)
                .padding(.top, 24)

                HStack(spacing: 0) {
                    Text("Информация".uppercased())
                        .font(.semibold(12))
                        .foreground(.darkGray())
                        .padding(.top, 24)
                        .padding([.leading, .trailing], 16)
                        .padding(.bottom, 12)
                    Spacer()
                }

                ZStack(alignment: .topLeading) {
                    DynamicHeightTextField(text: $description, height: $descriptionHeight)
                        .background(.paleBlue())

                    if description.isEmpty {
                        Text("Описание")
                            .foreground(.darkGray())
                            .padding(.top, 12)
                            .padding([.leading, .trailing], 19)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .frame(height: descriptionFieldHeight)
                .padding([.leading, .trailing], 16)

                HStack(spacing: 0) {
                    Text("Можете указать дополнительное описание для Вашей группы.")
                        .lineLimit(nil)
                        .font(.regular(12))
                        .foreground(.darkGray())
                        .padding(.top, 8)
                        .padding([.leading, .trailing], 16)
                    Spacer()
                }

                Spacer()
            }
        }
    }
}
