import Foundation

// MARK: - ProfileMediaData

struct ProfileMediaData: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var avatar: URL?
    var photosUrls: [URL] = []
}

// MARK: - FileData

struct FileData: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var fileName: String
    var url: URL
    var date: Date
}
