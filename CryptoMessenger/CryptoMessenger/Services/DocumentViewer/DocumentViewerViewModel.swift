import SwiftUI
import Combine

final class DocumentViewerViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Binding var isUploadFinished: Bool
    @Published var fileName: String
    var url: URL
    @Published var uploadedUrl: URL?

    // MARK: - Lifecycle

    init(url: URL, isUploadFinished: Binding<Bool>, fileName: String = "result.pdf") {
        self.url = url
        self._isUploadFinished = isUploadFinished
        self.fileName = fileName
        downloadFile(withUrl: self.url, fileName: fileName) { filePath in
            self.uploadedUrl = filePath
        }
    }

    private func downloadFile(withUrl url: URL,
                              fileName: String,
                              completion: @escaping ((_ filePath: URL?) -> Void)) {
        do {
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentDirectory.appendingPathComponent(fileName, isDirectory: false)
            let data = try Data(contentsOf: url)
            try data.write(to: filePath, options: .noFileProtection)
            completion(filePath)
            self.isUploadFinished = true
        } catch {
            debugPrint("an error happened while downloading or saving the file")
            completion(nil)
        }
    }
}
