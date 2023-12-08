import Foundation

enum SocialKey: String, Identifiable, CaseIterable {
    var id: UUID { UUID() }
    case facebook, vk, twitter, instagram
}
