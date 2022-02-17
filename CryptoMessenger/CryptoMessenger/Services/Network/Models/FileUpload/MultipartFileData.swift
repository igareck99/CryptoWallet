import Foundation

// MARK: - MultipartFileData

struct MultipartFileData {

    // MARK: - Internal Properties

    let file: String
    let mimeType: String
    let fileData: Data
    var field: String = "file"
    var formFields: [String: String] = [:]
    let boundary = "Boundary-\(UUID().uuidString)"
}
