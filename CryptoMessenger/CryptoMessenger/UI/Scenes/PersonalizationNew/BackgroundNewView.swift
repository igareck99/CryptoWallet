import SwiftUI

// MARK: - SelectPhotoBackgroundCellView

struct SelectPhotoBackgroundCellView: View {

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.profileBackground.gallery.image
                        .frame(width: 20, height: 20)
                }
                Text(R.string.localizable.profileBackgroundTitle())
                    .font(.light(17))
                    .foreground(.blue())
                R.image.registration.arrow.image.padding(.leading, 50)
            }
            Text(R.string.localizable.profileBackgroundWallpaper())
                .font(.regular(12))
                .foreground(.darkGray(12))
        }
    }
}

// MARK: - SelectBackgroundView

struct SelectBackgroundView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PersonalizationNewViewModel
    @State var showPhotoLibrary = false

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            List {
            VStack(alignment: .leading, spacing: 16) {
                SelectPhotoBackgroundCellView()
                    .onTapGesture {
                        showPhotoLibrary = true
                    }
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 8), count: 3), alignment: .center, spacing: 9) {
                    ForEach(0..<viewModel.backgroundPhotos.count, id: \.self) { index in
                            ZStack {
                                viewModel.backgroundPhotos[index]
                                    .resizable()
                                    .frame(width: (geometry.size.width - 48) / 3, height: 230)
                                    .overlay(viewModel.user.backGround == viewModel.backgroundPhotos[index] ?
                                             Color(.blue(0.4)): Color(.clear))
                                    .scaledToFill()
                                    .onTapGesture {
                                        if viewModel.user.backGround == viewModel.backgroundPhotos[index] {
                                            viewModel.user.backGround = Image(uiImage: UIImage())
                                        } else {
                                        viewModel.user.backGround = viewModel.backgroundPhotos[index]
                                            viewModel.send(.backgroundPreview)
                                    }
                                }
                                ZStack {
                                    Circle()
                                        .fill(Color(.blue()))
                                        .frame(width: 40, height: 40)
                                    R.image.profileBackground.approve.image
                                        .frame(width: 24, height: 24)
                                }.opacity(viewModel.user.backGround == viewModel.backgroundPhotos[index] ? 1 : 0)
                            }
                    }
                }
            }
            }.padding(.top, 16)
            .sheet(isPresented: $showPhotoLibrary) {
                NavigationView {
                    ImagePickerView(selectedImage: $viewModel.selectedImage, onSelectImage: { image in
                        guard let image = image else { return }
                        self.viewModel.addPhoto(image: image)
                    })
                        .ignoresSafeArea()
                        .navigationBarTitle(Text("Фото"))
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.personalizationBackground())
                            .font(.bold(15))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                        }, label: {
                            Text(R.string.localizable.profileDetailRightButton())
                                .font(.bold(15))
                                .foreground(.blue())
                        })
                    }
                }
        }
    }
}
