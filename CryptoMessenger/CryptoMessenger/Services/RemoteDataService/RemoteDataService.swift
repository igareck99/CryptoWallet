import Foundation

// MARK: - RemoteDataService

final class RemoteDataService {
    
    func fetchContentLength(for url: URL, completion: @escaping (_ contentLength: Int) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let contentLength = response.allHeaderFields["Content-Length"] as? String else {
                completion(0)
                return
            }
            guard let result = Int(contentLength) else {
                completion(0)
                return
            }
            completion(result)
        }
        task.resume()
    }
    
}
