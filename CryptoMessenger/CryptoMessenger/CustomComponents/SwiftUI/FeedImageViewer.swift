import SwiftUI

struct FeedImageView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @GestureState var draggingOffset: CGSize = .zero
    @State var showsShareView = false
    @Binding var showImageViewer: Bool

    var body: some View {
        ZStack {
            Color.black
                .opacity(1)
                .ignoresSafeArea()
            Spacer()
            ScrollView(.init()) {
                TabView(selection: $viewModel.selectedImageURL) {
                    ForEach(viewModel.profile.photosUrls, id: \.self) { image in
                        AsyncImage(
                            url: image,
                            placeholder: { ShimmerView() },
                            result: { Image(uiImage: $0).resizable() }
                        )
                            .frame(height: 375)
                            .tag(image)
                            .scaleEffect(viewModel.selectedImageURL == image ? (viewModel.imageScale > 1 ? viewModel.imageScale : 1) :1)
                            .offset(y: viewModel.imageViewerOffset.height)
                            .gesture(
                                MagnificationGesture().onChanged({ _ in
                                    withAnimation(.spring()) {
                                        viewModel.imageScale = 1
                                    }
                                })
                                    .simultaneously(with: TapGesture(count: 2).onEnded({
                                        withAnimation {
                                            viewModel.imageScale = viewModel.imageScale > 1 ? 1 : 4
                                        }
                                    })
                            )
                                )

                    }
                }
                .frame(height: 440)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            .overlay(
                VStack {
                    HStack {
                        R.image.photoEditor.backButton.image
                            .frame(width: 24,
                                   height: 24)
                            .onTapGesture {
                                withAnimation(.default) {
                                    showImageViewer = false
                                }
                            }
                        Spacer()
                        Text(R.string.localizable.photoEditorTitle())
                            .foregroundColor(Color.white)
                        Spacer()
                        R.image.photoEditor.dotes.image
                    }
                    .padding(.top, UIScreen.main.bounds.height / 22)
                    .padding(.horizontal, 16)
                    Spacer()
                    HStack {
                        R.image.photoEditor.share.image
                            .frame(width: 24,
                                   height: 24)
                            .onTapGesture {
                                withAnimation(.default) {
                                    guard let unwrappedUrl = viewModel.selectedImageURL else {
                                        return
                                    }
                                    showsShareView = true
                                    viewModel.uploadImage(url: unwrappedUrl)
                                }
                            }
                        Spacer()
                        Text("")
                        Spacer()
                        R.image.keyManager.trashBasket.image
                    }
                    .padding(.bottom, UIScreen.main.bounds.height / 21)
                    .padding(.horizontal, 16)
                }
            )
//            }
//        }
//        .background(Color.black)
        }
        .environmentObject(viewModel)
        .gesture(DragGesture().updating($draggingOffset, body: { value, outValue, _ in
            outValue = value.translation
            viewModel.onChange(value: draggingOffset)
            
        }).onEnded(viewModel.onEnd(value:)))
        .sheet(isPresented: $showsShareView) {
            ShareSheet(image: viewModel.imageToSend)
        }
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

// MARK: - ShareSheet (UIViewControllerRepresentable)

struct ShareSheet: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var image: UIImage

    // MARK: - Internal Methods

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [image],
                                                  applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: Context) {
    }
}
