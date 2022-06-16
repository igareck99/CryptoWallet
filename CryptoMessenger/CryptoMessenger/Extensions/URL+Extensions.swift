import Foundation

// MARK: - URL ()

extension URL {

    // MARK: - Internal Methods

    func fileSize() -> String {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: path)
            if let size = attribute[.size] as? NSNumber {
                return "\(size.doubleValue / 1000000.0) MB"
            }
        } catch {
            debugPrint("Error: \(error)")
        }
        return "0.0 MB"
    }

    func isReachable(completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }

    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
