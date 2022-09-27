import Foundation

// MARK: - FileViewModel

final class FileViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var sizeOfFile = ""
    var url: URL?
    let remoteDataService = RemoteDataService()

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
        remoteDataService.fetchContentLength(for: url) { contentLength in
            let value = round(10 * Double(contentLength) / 1024 / 1000) / 10
            self.sizeOfFile = String(value) + " MB"
        }
    }
}
