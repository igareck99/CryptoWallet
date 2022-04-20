import SwiftUI

// MARK: - SelectPhotoBackgroundCellView

struct SelectPhotoBackgroundCellView: View {

    // MARK: - Body

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(.blue(0.1)))
                    .frame(width: 40, height: 40)
                R.image.profileBackground.gallery.image
                    .frame(width: 20, height: 20)
            }
            HStack {
                Text(R.string.localizable.profileBackgroundTitle())
                    .font(.light(17))
                    .foreground(.blue())
                    .lineLimit(2)
                Spacer()
                R.image.registration.arrow.image
            }
            .padding(.leading, 16)
        }
    }
}

// MARK: - SelectBackgroundView

struct SelectBackgroundView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PersonalizationViewModel
    @State var showPhotoLibrary = false

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            Divider().padding(.top, 16)
            List {
                VStack(alignment: .leading, spacing: 16) {
                    SelectPhotoBackgroundCellView()
                        .background(.white())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            showPhotoLibrary = true
                        }
                    Text(R.string.localizable.profileBackgroundWallpaper())
                        .font(.regular(12))
                        .foreground(.darkGray(12))
                        .padding(.top, 8)
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 8),
                                             count: 3), alignment: .center, spacing: 9) {
                        ForEach(0..<viewModel.backgroundPhotos.count, id: \.self) { index in
                            ZStack {
                                viewModel.backgroundPhotos[index]
                                    .resizable()
                                    .frame(width: (geometry.size.width - 48) / 3, height: 230)
                                    .overlay(viewModel.dataImage == index ?
                                             Color(.blue(0.4)): Color(.clear))
                                    .scaledToFill()
                                    .onTapGesture {
                                        if viewModel.user.backGround == viewModel.backgroundPhotos[index] {
                                            viewModel.updateImage(index: -1)
                                            viewModel.user.backGround = Image(uiImage: UIImage())
                                        } else {
                                            viewModel.user.backGround = viewModel.backgroundPhotos[index]
                                            viewModel.updateImage(index: index)
                                            viewModel.send(.backgroundPreview)
                                        }
                                    }
                                ZStack {
                                    Circle()
                                        .fill(Color(.blue()))
                                        .frame(width: 40, height: 40)
                                    R.image.profileBackground.approve.image
                                        .frame(width: 24, height: 24)
                                }.opacity(viewModel.dataImage == index ? 1 : 0)
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }.padding(.top, 24)
                .sheet(isPresented: $showPhotoLibrary) {
                    ImagePickerView(selectedImage: $viewModel.selectedImage)
                        .ignoresSafeArea()
                        .navigationBarTitle(Text("Фото"))
                        .navigationBarTitleDisplayMode(.inline)
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.personalizationBackground())
                            .font(.bold(15))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.send(.onProfile)
                        }, label: {
                            Text(R.string.localizable.profileDetailRightButton())
                                .font(.semibold(15))
                                .foreground(.blue())
                        })
                    }
                }
        }
    }
}
