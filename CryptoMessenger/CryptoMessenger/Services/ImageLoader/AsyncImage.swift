import SwiftUI

// swiftlint:disable all

// MARK: - AsyncImage

struct AsyncImage<Placeholder: View, ResultmageView: View>: View {

    // MARK: - Private Properties

    @StateObject private var loader: ImageLoader
    @State private var urlReachable = false
    private let url: URL?
    private let placeholder: Placeholder
    private let result: (UIImage) -> Image
	private let resultView: ((UIImage) -> ResultmageView)?

    // MARK: - LifeCycle

    init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder result: @escaping (UIImage) -> Image = Image.init(uiImage:),
		@ViewBuilder resultView: @escaping (UIImage) -> ResultmageView = { _ in EmptyView().opacity(0) }
    ) {
        self.placeholder = placeholder()
        self.result = result
		self.resultView = resultView
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
				if let resultView = resultView {
					resultView(image)
				} else {
					result(image)
				}
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
