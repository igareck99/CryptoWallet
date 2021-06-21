import Foundation

// MARK: - RelationshipResponse

struct RelationshipResponse: Codable {
    let relationshipTypes: [RelationshipType]?
}

// MARK: - RelationshipItem

struct RelationshipType: Codable {
    let id, displayValue, category: String?
}
