import Foundation

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

    // MARK: - Methods

    func fetchContentLength(for url: URL,
                            httpMethod: RemoteDataRequestType,
                            completion: @escaping (_ contentLength: Int?) -> Void)
    func downloadData(withUrl url: URL,
                      httpMethod: RemoteDataRequestType,
                      completion: @escaping ((_ filePath: Data?) -> Void))
}

// MARK: - RemoteDataService

final class RemoteDataService: RemoteDataServiceProtocol, ObservableObject {

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
}
