import Foundation
import Combine

// MARK: - PDFKitViewModel

final class PDFKitViewModel: ObservableObject {

    var url: URL
    @Published var data = Data()

    // MARK: - Lifecycle

    init(url: URL) {
        self.url = url
    }

    func downloadPdf(completion: @escaping (Data?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
       }
}
