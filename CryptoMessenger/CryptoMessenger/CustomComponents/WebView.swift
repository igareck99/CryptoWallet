import SafariServices
import SwiftUI
import WebKit

// MARK: - SFSafariViewWrapper

struct SFSafariViewWrapper: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var link: URL

    // MARK: - Internal Methods

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        SFSafariViewController(url: link)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
    }

    func toURL(_ link: String) -> URL {
        guard let url = try? link.asURL() else { fatalError("Invalid URL") }
        return url
    }
}
