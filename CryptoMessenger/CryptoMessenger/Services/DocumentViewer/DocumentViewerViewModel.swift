import Combine
import SwiftUI

final class DocumentViewerViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Binding var isUploadFinished: Bool
    @Published var fileName: String
    @Published var uploadedUrl: URL?
    private let remoteDataService: RemoteDataServiceProtocol
    var url: URL

    // MARK: - Lifecycle

    init(
        url: URL,
        isUploadFinished: Binding<Bool>,
        fileName: String,
        remoteDataService: RemoteDataServiceProtocol = RemoteDataService()
    ) {
        self.url = url
        self._isUploadFinished = isUploadFinished
        self.fileName = fileName
        self.remoteDataService = remoteDataService
        self.load()
    }

    private func load() {
        Task {
            let result = await remoteDataService.downloadDataRequest(url: url)
            self.isUploadFinished = true
            debugPrint("downloadDataRequest url: \(String(describing: result?.0))")
            debugPrint("downloadDataRequest request: \(String(describing: result?.1))")
            guard let fileUrl = result?.0,
                  let savedUrl = self.saveFile(fileUrl: fileUrl, name: fileName) else {
                debugPrint("downloadDataRequest FAILED")
                return
            }
            debugPrint("downloadDataRequest savedUrl: \(savedUrl)")
            await MainActor.run {
                self.uploadedUrl = savedUrl
            }
        }
    }

    private func saveFile(fileUrl: URL, name: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentDirectory.appendingPathComponent(name, isDirectory: false)
        guard let data = try? Data(contentsOf: fileUrl) else { return nil }
        try? data.write(to: filePath, options: .noFileProtection)
        return filePath
    }

    private func downloadFile(
        withUrl url: URL,
        fileName: String,
        completion: @escaping ((_ filePath: EmptyFailureResult<URL>) -> Void)
    ) {
        do {
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentDirectory.appendingPathComponent(fileName, isDirectory: false)
            let data = try Data(contentsOf: url)
            try data.write(to: filePath, options: .noFileProtection)
            completion(.success(filePath))
        } catch {
            debugPrint("an error happened while downloading or saving the file")
            completion(.failure)
        }
    }
}
