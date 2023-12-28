import Foundation
import Combine

// swiftlint: disable: all

// MARK: - RemoteDataRequestType

enum RemoteDataRequestType: String {

    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - RemoteDataHeaderFields

enum RemoteDataHeaderFields: String {

    case contentLength = "Content-Length"
}

// MARK: - RemoteDataServiceProtocol

protocol RemoteDataServiceProtocol {

    // MARK: - Properties

    var dataSizePublisher: Published<SavedExpectData>.Publisher { get }
    var dataState: SavedExpectData { get }
    var isFinishedLaunch: Published<URL?>.Publisher { get }

    // MARK: - Methods

    func fetchContentLength(
        for url: URL,
        httpMethod: RemoteDataRequestType,
        completion: @escaping (_ contentLength: Int?) -> Void
    )

    func downloadData(
        withUrl url: URL,
        httpMethod: RemoteDataRequestType,
        completion: @escaping ((_ filePath: Data?) -> Void)
    )

    func downloadDataRequest(url: URL) async -> (URL, URLResponse)?
    func downloadRequest(url: URL) async -> (Data, URLResponse)?
    func fetchContentLength(url: URL) -> Int?
    func downloadWithBytes(url: URL) async -> (Data, URLResponse)?
}

// MARK: - RemoteDataService

final class RemoteDataService: NSObject, RemoteDataServiceProtocol, ObservableObject {

    // MARK: - Internal properties
    
    
    var dataSizePublisher: Published<SavedExpectData>.Publisher { $dataState }
    var isFinishedLaunch: Published<URL?>.Publisher { $isUploadFinished }
    @Published var dataState = SavedExpectData()
    @Published var isUploadFinished: URL?

    // MARK: - Static Properties

    static let shared = RemoteDataService()

    // MARK: - Internal Methods

    func fetchContentLength(
        for url: URL,
        httpMethod: RemoteDataRequestType,
        completion: @escaping (_ contentLength: Int?) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let contentLength = response
                .allHeaderFields[RemoteDataHeaderFields.contentLength.rawValue] as? String else {
                completion(nil)
                return
            }
            guard let result = Int(contentLength) else {
                completion(nil)
                return
            }
            completion(result)
        }
        task.resume()
    }
    
    func downloadWithBytes(url: URL) async -> (Data, URLResponse)? {
        let request = URLRequest(url: url)
        let result = try? await URLSession.shared.bytes(for: request)
        let (asyncBytes, urlResponse) = (result?.0, result?.1)
        let length = Int(urlResponse?.expectedContentLength ?? 0)
        var bytes: [UInt8] = []
        if let asyncBytes = asyncBytes {
            do {
                for try await byte in asyncBytes {
                    bytes.append(byte)
                    if Int(bytes.count / self.dataState.savedBytes) > 32 {
                        self.dataState = SavedExpectData(
                            savedBytes: bytes.count,
                            expectBytes: length
                        )
                    }
                }
            } catch {
                debugPrint("Error in AsyncBytes  \(error)")
            }
        }
        guard let response = urlResponse else { return nil }
        let resultData = Data(bytes)
        return (resultData, response)
    }

    func downloadDataRequest(url: URL) async -> (URL, URLResponse)? {
        let request = URLRequest(url: url)
        let result = try? await URLSession.shared.download(for: request)
        return result
    }
    
    func downloadRequest(url: URL) async -> (Data, URLResponse)? {
        let request = URLRequest(url: url)
        let result = try? await URLSession.shared.data(for: request)
        return result
    }
    
    func fetchContentLength(url: URL) -> Int? {
        var request = URLRequest(url: url)
        request.httpMethod = RemoteDataRequestType.get.rawValue
        let result = URLSession.shared.dataTask(with: request)
        guard let size = result.currentRequest?
            .allHTTPHeaderFields?[RemoteDataHeaderFields.contentLength.rawValue] else {
            return nil
        }
        guard let result = Int(size) else {
            return nil
        }
        return result
    }

    func downloadData(
        withUrl url: URL,
        httpMethod: RemoteDataRequestType,
        completion: @escaping ((_ filePath: Data?) -> Void)
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let dataTask = URLSession.shared.dataTask(with: request) {  data, _, _ in
            guard let data = data else { completion(nil); return }
            completion(data)
        }
        dataTask.resume()
    }
    
    func downloadDataWithSize(
        withUrl url: URL,
        httpMethod: RemoteDataRequestType
    ) async {
        Task {
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let session = URLSession(
                configuration: configuration,
                delegate: self,
                delegateQueue: operationQueue
            )
            let downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
    }
    
    private func handleRequestResponse(
        session: URLSession,
        downloadTask: URLSessionDownloadTask,
        location: URL
    ) async {
        guard let url = downloadTask.originalRequest?.url,
              let videoPath = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
              ).first else {
            return
        }
        let destinationURL = videoPath.appendingPathComponent(url.lastPathComponent + ".mp4")
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.copyItem(at: location, to: destinationURL)
        await MainActor.run {
            isUploadFinished = destinationURL
        }
    }
}

// MARK: - RemoteDataService

extension RemoteDataService: URLSessionDownloadDelegate {

    // MARK: - Internal Properties

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        Task {
            await handleRequestResponse(
                session: session,
                downloadTask: downloadTask,
                location: location
            )
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
    }
}

// MARK: - SavedRemainedData

struct SavedExpectData {

    // MARK: - Internal Properties

    var savedBytes: Int = 1
    var expectBytes: Int = 1
}
