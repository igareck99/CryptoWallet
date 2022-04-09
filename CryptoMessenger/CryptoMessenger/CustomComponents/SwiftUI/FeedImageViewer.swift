import SwiftUI

struct FeedImageView: View {

    @StateObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var viewModel: FeedImageViewerViewModel
    @GestureState var draggingOffset: CGSize = .zero
    @State var showsShareView = false

    var body: some View {
        ZStack {
            Color.black
                .opacity(viewModel.bgOpacity)
                .ignoresSafeArea()
            Spacer()
            ScrollView(.init()) {
            TabView(selection: $profileViewModel.selectedImageURL) {
                ForEach(profileViewModel.profile.photosUrls, id: \.self) { image in
                    AsyncImage(
                        url: image,
                        placeholder: { ShimmerView() },
                        result: { Image(uiImage: $0).resizable() }
                    )
                        .resizable()
                        .frame(height: 375)
                        .aspectRatio(contentMode: .fit)
                        .tag(image)
                        .scaleEffect(viewModel.selectedImageId == image ? (viewModel.imageScale > 1 ? viewModel.imageScale : 1)
                                     :1)
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
            .environmentObject(viewModel)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .overlay(
                VStack {
                    HStack {
                        R.image.photoEditor.backButton.image
                            .frame(width: 24,
                                   height: 24)
                            .onTapGesture {
                                withAnimation(.default) {
                                    viewModel.showImageViewer.toggle()
                                }
                            }
                        Spacer()
                        Text(R.string.localizable.photoEditorTitle())
                            .foreground(.white())
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
                                    showsShareView = true
                                }
                            }
                        Spacer()
                        Spacer()
                        R.image.keyManager.trashBasket.image
                    }
                    .padding(.bottom, UIScreen.main.bounds.height / 21)
                    .padding(.horizontal, 16)
                }
            )
            }
        }
        .background(Color.black)
        .gesture(DragGesture().updating($draggingOffset, body: { value, outValue, _ in
            outValue = value.translation
            viewModel.onChange(value: draggingOffset)
        }).onEnded(viewModel.onEnd(value:)))
        .sheet(isPresented: $showsShareView) {
            ShareSheet(items: [viewModel.selectedImageId])
        }
    }
}

class FeedImageViewerViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var allImages: [String] = ["image1","image2","image3","image4","image5"]
    @Published var selectedImages : [String] = []
    @Published var showImageViewer = false
    @Published var selectedImageId = ""
    @Published var imageViewerOffset: CGSize = .zero
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1

    // MARK: - Internal Methods
    func onChange(value: CGSize) {
        imageViewerOffset = value
        let halgHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halgHeight
        withAnimation(.default) {
            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var transtlation = value.translation.height
            if transtlation < 0 {
                transtlation  = -transtlation
            }
            if transtlation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                showImageViewer = false
                imageViewerOffset = .zero
                bgOpacity = 1
            }
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

    var items: [String]

    // MARK: - Internal Methods

    func makeUIViewController(context: Context) -> UIActivityViewController {
        var images: [UIImage] = []
        for item in items {
            print(item)
            images.append(UIImage(named: item) ?? UIImage())
        }
        print(images)
        let controller = UIActivityViewController(activityItems: images,
                                                  applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
