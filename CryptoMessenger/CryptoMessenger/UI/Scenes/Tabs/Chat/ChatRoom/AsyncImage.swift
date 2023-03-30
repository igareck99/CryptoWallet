import SwiftUI

// swiftlint:disable all

// MARK: - AsyncImage

struct AsyncImage<Placeholder: View, ResultmageView: View>: View {
    
    var defaultUrl: URL?
    var updatingPhoto: Bool

    // MARK: - Private Properties

    @StateObject private var loader: ImageLoader
    @State private var urlReachable = false
    @Binding var url: URL?
    @Binding var isAvatarLoading: Bool
    private let placeholder: Placeholder
    private let result: (UIImage) -> Image?
    private let resultView: (UIImage) -> ResultmageView

    // MARK: - LifeCycle

    init(
        defaultUrl: URL?,
        updatingPhoto: Bool = false,
        url: Binding<URL?>? = .constant(nil),
        isAvatarLoading: Binding<Bool> = .constant(false),
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder result: @escaping (UIImage) -> Image? = { _ in return nil },
        @ViewBuilder resultView: @escaping (UIImage) -> ResultmageView = { _ in EmptyView().opacity(0) }
    ) {
        self.defaultUrl = defaultUrl
        self.updatingPhoto = updatingPhoto
        self.placeholder = placeholder()
        self.result = result
        self.resultView = resultView
        self._url = url ?? Binding.constant(nil)
        self._isAvatarLoading = isAvatarLoading
        if let newUrl = url?.wrappedValue {
            _loader = StateObject(wrappedValue: ImageLoader(url: newUrl))
        } else {
            _loader = StateObject(wrappedValue: ImageLoader(url: defaultUrl))
        }
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                updateState()
                loader.load(defaultUrl)
            }
            .onChange(of: url) { value in
                loader.load(value)
            }
    }

    // MARK: - Body Properties

    private var content: some View {
        Group {
            if isAvatarLoading {
                progressView
            } else if let image = loader.image {
                if let imgView = result(image) {
                    imgView
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
            .tint(Color(.blue()))
    }

    private func updateState() {
        if updatingPhoto {
            url?.isReachable(completion: { flag in
                self.urlReachable = flag
            })
        } else {
            defaultUrl?.isReachable(completion: { flag in
                self.urlReachable = flag
            })
        }
    }
}
