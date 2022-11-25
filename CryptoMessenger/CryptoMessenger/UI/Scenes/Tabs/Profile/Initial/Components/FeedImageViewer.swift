import SwiftUI

// MARK: - FeedImageViewerViewModel

final class FeedImageViewerViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var imageViewerOffset: CGSize = .zero
    @Published var bgOpacity = 1.0
    @Published var imageScale: CGFloat = 1
    @Binding var isClosed: Bool

    // MARK: - Lifecycle

    init(isClosed: Binding<Bool>) {
        _isClosed = isClosed
    }

    // MARK: - Internal Methods

    func onChange(value: CGSize) {
        imageViewerOffset = value
        let progress = imageViewerOffset.height / (UIScreen.main.bounds.height * 0.5)
        withAnimation {
            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }

    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut(duration: 0.1)) {
            var translation = value.translation.height
            if translation < 0 {
                translation = -translation
            }
            if translation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                isClosed.toggle()
                imageViewerOffset = .zero
                bgOpacity = 1
            }
        }
    }
}

// MARK: - FeedImageViewerView

struct FeedImageViewerView: View {

    // MARK: - Private Properties

    @GestureState private var draggingOffset: CGSize = .zero
    @StateObject private var viewModel: FeedImageViewerViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    @Binding var imageToShare: UIImage?
    @Binding private var selectedPhoto: URL?
    @Binding var showImageViewer: Bool
    @State var showDeleteAlert = false
    @State var showShareView = false
	@State var isShownTools = true

    // MARK: - Lifecycle

    init(selectedPhoto: Binding<URL?>, showImageViewer: Binding<Bool>,
         profileViewModel: ProfileViewModel, imageToShare: Binding<UIImage?>) {
        let vm = FeedImageViewerViewModel(isClosed: showImageViewer)
        _selectedPhoto = selectedPhoto
        _viewModel = StateObject(wrappedValue: vm)
        _showImageViewer = showImageViewer
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
        _imageToShare = imageToShare
    }

    // MARK: - Body

    var body: some View {
		ZStack(alignment: .center) {
            Color(.darkBlack())
                .opacity(viewModel.bgOpacity)
                .ignoresSafeArea()

//            ScrollView {
                AsyncImage(
                    url: selectedPhoto,
                    placeholder: { ShimmerView()
                            .frame(height: UIScreen.main.bounds.width)
                    },
                    result: { Image(uiImage: $0).resizable() }
                )
                .scaledToFit()
                .animation(.spring())
                .scaleEffect(
                    viewModel.imageScale > 1 ? viewModel.imageScale : 1
                )
                .offset(y: viewModel.imageViewerOffset.height)
                .gesture(
                    MagnificationGesture().onChanged { value in
                        viewModel.imageScale = value
                    }.onEnded { _ in
                        withAnimation(.spring()) {
                            viewModel.imageScale = 1
                        }
                    }
                        .simultaneously(with: DragGesture(minimumDistance:
                                                            viewModel.imageScale == 1 ? .infinity : .zero))
                        .simultaneously(with: TapGesture(count: 2).onEnded {
                            withAnimation {
                                viewModel.imageScale = viewModel.imageScale > 1 ? 1 : 4
                            }
                        })
                )
//            }
//            .ignoresSafeArea()
//            .transition(.scale.combined(with: .opacity))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
			VStack(alignment: .center) {
                HStack(alignment: .center) {
                    R.image.photoEditor.backButton.image
						.padding(.bottom, 8)
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            withAnimation(.default) {
                                selectedPhoto = nil
                                viewModel.isClosed = false
                            }
                        }
                    Spacer()
                    Text(R.string.localizable.photoEditorTitle())
                        .foregroundColor(Color.white)
						.padding(.bottom, 8)
                    Spacer()
                    R.image.photoEditor.dotes.image
						.padding(.bottom, 8)
						.opacity(0)
                }
                .padding(.top, UIScreen.main.bounds.height / 22)
                .padding(.horizontal, 16)
				.background(Color.black)
				.opacity(isShownTools ? 1 : 0)
                Spacer()
				HStack(alignment: .center) {
                    R.image.photoEditor.share.image
						.padding(.top, 8)
                        .onTapGesture {
                            showShareView = true
                        }
                    Spacer()
                    R.image.photoEditor.brush.image
						.padding(.top, 8)
                        .onTapGesture {
                            showDeleteAlert = true
                        }
                }
                .padding(.bottom, UIScreen.main.bounds.height / 21)
                .padding(.horizontal, 16)
				.background(Color.black)
				.opacity(isShownTools ? 1 : 0)
            }
        )
        .sheet(isPresented: $showShareView, content: {
            FeedShareSheet(image: imageToShare)
                })
        .alert(isPresented: $showDeleteAlert, content: {
            let primaryButton = Alert.Button.default(Text("Да")) {
                profileViewModel.mediaService.deletePhotoFeed(url: selectedPhoto?.absoluteString ?? "") { url in
                    showImageViewer = false
                    profileViewModel.updateFeedAfterDelete(url: url)
                }
            }
            let secondaryButton = Alert.Button.destructive(Text("Нет")) {
                showDeleteAlert = false
            }
            return Alert(title: Text("Удалить фото?"),
                         message: Text(""),
                         primaryButton: primaryButton,
                         secondaryButton: secondaryButton)
        })
		.onTapGesture {
			isShownTools.toggle()
		}
        .gesture(
            DragGesture().updating($draggingOffset) { value, outValue, _ in
                outValue = value.translation
                viewModel.onChange(value: draggingOffset)
            }.onEnded { value in
                viewModel.onEnd(value: value)
            }
        )
    }
}

// MARK: - FeedShareSheet (UIViewControllerRepresentable)

struct FeedShareSheet: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var image: UIImage?

    // MARK: - Internal Methods

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [image],
                                                  applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
