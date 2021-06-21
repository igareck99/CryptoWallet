import Foundation

// MARK: - OccasionResponse

struct OccasionResponse: Codable {
    let occasions: [OccasionItem]?
}

// MARK: - OccasionItem

struct OccasionItem: Codable {
    let id, displayValue: String?
    let backgroundImageUrl: String?
    let relationshipTypes: [String]?
}
