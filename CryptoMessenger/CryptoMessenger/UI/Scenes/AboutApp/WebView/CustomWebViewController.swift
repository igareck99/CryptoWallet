import UIKit
import WebKit

final class CustomWebViewController: UIViewController {

    private var webView: WKWebView!
    private var url: String!

    convenience init(url: String) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
    }

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: self.url) else { return }
        webView.load(URLRequest(url: url))
    }

}
