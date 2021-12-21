import SwiftUI
import WebKit
import SafariServices

// MARK: - SFSafariViewWrapper

struct SFSafariViewWrapper: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    @Binding var url: String

    // MARK: - Internal Methods

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: toURL(url))
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }

    func toURL(_ link: String) -> URL {
        guard let url = try? link.asURL() else { fatalError("Invalid URL") }
        return url
    }
}
