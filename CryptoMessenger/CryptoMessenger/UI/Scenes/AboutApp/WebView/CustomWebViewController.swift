import UIKit
import WebKit

class CustomWebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var url: String!

    convenience init(url: String) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: self.url)!
        webView.load(URLRequest(url: url))
    }

}
