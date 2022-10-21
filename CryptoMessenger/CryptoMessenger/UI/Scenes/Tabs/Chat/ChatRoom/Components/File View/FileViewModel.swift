import Foundation
import Combine

// MARK: - FileViewModel

final class FileViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var sizeOfFile = ""
    var url: URL?

    // MARK: - Private Properties

    let remoteDataService = RemoteDataService()
    private var subscriptions = Set<AnyCancellable>()

    init(url: URL?) {
        self.url = url
        getSize()
    }

    // MARK: - Private Methods

    private func getSize() {
        guard let url = url else {
            self.sizeOfFile = "0 MB"
            return
        }
        DispatchQueue.global(qos: .background).async {
            self.remoteDataService.fetchContentLength(for: url, httpMethod: .get) { contentLength in
                guard let length = contentLength else { return }
                var value = round(10 * Double(length) / 1024) / 10
                if value < 1000 {
                    self.sizeOfFile = String(value) + " KB"
                } else {
                    value = round(10 * Double(length) / 1024 / 1000) / 10
                    self.sizeOfFile = String(value) + " MB"
                }
            }
        }
    }
}
