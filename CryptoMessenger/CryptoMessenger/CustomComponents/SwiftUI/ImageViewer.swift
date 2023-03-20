import SwiftUI

// MARK: - ImageViewerViewModel

final class ImageViewerViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var allImages: [String] = []
    @Published var selectedImageID = ""
    @Published var imageViewerOffset: CGSize = .zero
    @Published var bgOpacity = 1.0
    @Published var imageScale: CGFloat = 1
    @Published var isClosed = false

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

// MARK: - ImageViewer

struct ImageViewer: View {

    // MARK: - Private Properties

    @GestureState private var draggingOffset: CGSize = .zero
    @StateObject private var viewModel: ImageViewerViewModel
    @Binding private var selectedPhoto: URL?

    // MARK: - Lifecycle

    init(selectedPhoto: Binding<URL?>, allImages: [String], selectedImageID: String) {
        let vm = ImageViewerViewModel()
        vm.selectedImageID = selectedImageID
        vm.allImages = allImages
        _selectedPhoto = selectedPhoto
        _viewModel = StateObject(wrappedValue: vm)
    }

    // MARK: - Body

    var body: some View {
		ZStack(alignment: .center) {
            Color(.black())
                .opacity(viewModel.bgOpacity)
                .ignoresSafeArea()

//            ScrollView(.init()) {
                AsyncImage(
                    defaultUrl: selectedPhoto,
                    placeholder: { ShimmerView() },
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
                        .simultaneously(with: DragGesture(minimumDistance: viewModel.imageScale == 1 ? .infinity : .zero))
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
            Button(action: {
                withAnimation {
                    selectedPhoto = nil
                }
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.35))
                    .clipShape(Circle())
            })
                .padding(.top, 64)
                .padding(.trailing, 16)
                .opacity(viewModel.bgOpacity)

            ,alignment: .topTrailing
        )
        .gesture(
            DragGesture().updating($draggingOffset) { value, outValue, _ in
                outValue = value.translation
                viewModel.onChange(value: draggingOffset)
            }.onEnded { value in
                viewModel.onEnd(value: value)
            }
        )
        .onChange(of: viewModel.isClosed) { isClosed in
            if isClosed { selectedPhoto = nil }
        }
    }
}
