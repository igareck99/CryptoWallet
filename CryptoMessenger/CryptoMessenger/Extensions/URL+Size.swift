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
}
