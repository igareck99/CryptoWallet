import SwiftUI
import Combine

// MARK: - AboutAppViewModelDelegate

protocol AboutAppViewModelDelegate: ObservableObject {

    var resources: AboutAppSourcesable.Type { get }

    var appVersion: String { get }
    
    var safari: SFSafariViewWrapper? { get }

    var urlToOpen: URL? { get }

    var showWebView: Binding<Bool> { get set }

    func onPoliticTap()

    func onUsageTap()
}

// MARK: - AboutAppViewModel

final class AboutAppViewModel: AboutAppViewModelDelegate {

    // MARK: - Internal Properties

    let resources: AboutAppSourcesable.Type
    @Published var appVersion = ""
    @Published var urlToOpen: URL?
    var safari: SFSafariViewWrapper?
    var urlOfPolitic: URL?
    var urlOfUsage: URL?

    // MARK: - Private Properties

    private var showWebViewState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var showWebView: Binding<Bool> = .init(
        get: {
            self.showWebViewState
        },
        set: { newValue in
            self.showWebViewState = newValue
        }
    )

    // MARK: - Lifecycle

    init(resources: AboutAppSourcesable.Type = AboutAppSources.self) {
        self.resources = resources
        updateData()
    }

    func onPoliticTap() {
        guard let url = urlOfPolitic else {
            return
        }
        urlToOpen = url
        self.safari = SFSafariViewWrapper(link: url)
        showWebView.wrappedValue = true
    }

    func onUsageTap() {
        guard let url = urlOfUsage else {
            return
        }
        urlToOpen = url
        showWebView.wrappedValue = true
        self.safari = SFSafariViewWrapper(link: url)
    }

    // MARK: - Private Methods

    private func updateData() {
        // TODO: - Тут будут выставляться ссылки
        appVersion = "1.10.201"
        urlOfPolitic = URL(string: "https://gitlab.zelenocodes.ru/auradevteam/ios/auraios/-/merge_requests")
        urlOfUsage = URL(string: "https://orioks.miet.ru")
    }
}
