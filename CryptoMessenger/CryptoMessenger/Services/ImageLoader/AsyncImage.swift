import SwiftUI

// MARK: - AsyncImage

struct AsyncImage<Placeholder: View>: View {

    // MARK: - Private Properties

    @StateObject private var loader: ImageLoader
    @State private var urlReachable = false
    private let url: URL?
    private let placeholder: Placeholder
    private let result: (UIImage) -> Image

    // MARK: - LifeCycle

    init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder result: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.result = result
        self.url = url
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                updateState()
                loader.load(url)
            }
    }

    // MARK: - Body Properties

    private var content: some View {
        Group {
            if let image = loader.image {
                result(image)
            } else {
                if urlReachable {
                    progressView
                } else {
                    placeholder
                }
            }
        }
    }

    private var progressView: some View {
        ProgressView()
            .background(.blue(0.1))
            .tint(Color(.blue()))
    }

    private func updateState() {
        url?.isReachable(completion: { flag in
            self.urlReachable = flag
        })
    }
}
