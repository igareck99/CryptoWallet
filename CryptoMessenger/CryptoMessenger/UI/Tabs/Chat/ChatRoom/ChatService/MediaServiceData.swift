import Foundation

// MARK: - ProfileMediaData

struct ProfileMediaData: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var avatar: URL?
    var photosUrls: [URL] = []
}

// MARK: - FileData

struct FileData: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var fileName: String
    var url: URL?
    var date: Date

    // MARK: - Static Methods

    static func makeEmptyFile() -> FileData {
        return FileData(fileName: "",
                        url: URL(string: ""),
                        date: Date())
    }
}
