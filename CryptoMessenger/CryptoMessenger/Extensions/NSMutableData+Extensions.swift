import Foundation

// MARK: NSMutableData ()

extension NSMutableData {

    // MARK: - Internal Methods

    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
