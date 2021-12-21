import SwiftUI
import WebKit
import SafariServices

// MARK: - WebViewPreview

struct WebViewPreview: View {

    // MARK: - Internal Properties

    var text = "https://proglib.io/p/vzaimodeystvie-swiftui-s-vebom-chast-pervaya-webview-2021-04-03"
    @State var showWebView = false

    // MARK: - Body

    var body: some View {
        VStack {
            Button(action: {
                showWebView = true
            }, label: {
                Text("Открыть")
                    .font(.bold(15))
                    .foreground(.white())
            }).frame(width: 225, height: 44, alignment: .center)
                .background(.blue())
                .cornerRadius(8)
        }.fullScreenCover(isPresented: $showWebView, content: {
            SFSafariViewWrapper(url: text)
    })
    }
}

// MARK: - SFSafariViewWrapper

struct SFSafariViewWrapper: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    let url: String

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
