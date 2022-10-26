import Foundation
import Combine

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
    var isFinishedLaunch: Published<URL?>.Publisher { get }

    // MARK: - Methods

    func fetchContentLength(for url: URL,
                            httpMethod: RemoteDataRequestType,
                            completion: @escaping (_ contentLength: Int?) -> Void)
    func downloadData(withUrl url: URL,
                      httpMethod: RemoteDataRequestType,
                      completion: @escaping ((_ filePath: Data?) -> Void))
}

// MARK: - RemoteDataService

final class RemoteDataService: NSObject, RemoteDataServiceProtocol, ObservableObject {

    // MARK: - Internal properties

    var dataSizePublisher: Published<SavedExpectData>.Publisher { $dataState }
    var isFinishedLaunch: Published<URL?>.Publisher { $isUploadFinished }
    @Published var dataState = SavedExpectData(saved: "", expect: "")
    @Published var isUploadFinished: URL?

    // MARK: - Static Properties

    static let shared = RemoteDataService()

    // MARK: - Internal Methods

    func fetchContentLength(for url: URL,
                            httpMethod: RemoteDataRequestType,
                            completion: @escaping (_ contentLength: Int?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let contentLength = response.allHeaderFields[RemoteDataHeaderFields.contentLength.rawValue] as? String else {
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

    func downloadData(withUrl url: URL,
                      httpMethod: RemoteDataRequestType,
                      completion: @escaping ((_ filePath: Data?) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let dataTask = URLSession.shared.dataTask(with: request) {  data, _, _ in
            do {
                let data = try Data(contentsOf: url)
                completion(data)
            } catch {
                debugPrint("An error happened while downloading or saving the file")
                completion(nil)
            }
        }
        dataTask.resume()
    }

    func downloadDataWithSize(withUrl url: URL,
                              httpMethod: RemoteDataRequestType) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
}

// MARK: - RemoteDataService

extension RemoteDataService: URLSessionDownloadDelegate {

    // MARK: - Internal Properties

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = videoPath.appendingPathComponent(url.lastPathComponent + ".mp4")
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.isUploadFinished = destinationURL
        } catch let error {
            debugPrint("Copy Error: \(error.localizedDescription)")
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            var bytesWritten = round(10 * Double(totalBytesWritten) / 1024) / 10
            var resultWritten = ""
            var bytesExpect = round(10 * Double(totalBytesWritten) / 1024) / 10
            var resultExpect = ""
            if bytesWritten < 1000 {
                resultWritten = String(bytesWritten) + " KB"
            } else {
                bytesWritten = round(10 * Double(bytesWritten) / 1024 / 1000) / 10
                resultWritten = String(bytesWritten) + " MB"
            }
            if bytesExpect < 1000 {
                resultExpect = String(bytesExpect) + " KB"
            } else {
                bytesExpect = round(10 * Double(bytesExpect) / 1024 / 1000) / 10
                resultExpect = String(bytesExpect) + " MB"
            }
            let result = SavedExpectData(saved: resultWritten,
                                         expect: resultExpect,
                                         savedBytes: Int(totalBytesWritten),
                                         expectBytes: Int(totalBytesExpectedToWrite))
            self.dataState = result
        }
    }
}

// MARK: - SavedRemainedData

struct SavedExpectData {

    // MARK: - Internal Properties

    var saved: String
    var expect: String
    var savedBytes: Int = 0
    var expectBytes: Int = 1
}
