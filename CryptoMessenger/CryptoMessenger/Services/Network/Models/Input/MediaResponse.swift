import Foundation

// MARK: - MediaResponse

struct MediaResponse: Codable {

    // MARK: - Internal Properties

    var original: URL?
    var preview: URL?
}

// MARK: - SocialResponse

struct SocialResponse: Codable {

    // MARK: - Internal Properties

    var sort_order: Int
    var social_type: String
    var url: String

}
