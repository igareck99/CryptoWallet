import Foundation

// MARK: - MediaResponse

struct MediaResponse: Codable {

    // MARK: - Internal Properties

    var original: URL?
    var preview: URL?
    
    private enum CodingKeys : String, CodingKey {
        case original = "original", preview = "preview"
    }
}

// MARK: - SocialResponse

struct SocialResponse: Codable {

    // MARK: - Internal Properties

    let sortOrder: Int
    let socialType: String
    let url: String

    private enum CodingKeys : String, CodingKey {
        case sortOrder = "sort_order", socialType = "social_type", url
    }

}
