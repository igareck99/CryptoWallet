import Foundation

// MARK: - ProfileDetailType

enum ProfileDetailType: CaseIterable {

    // MARK: - Types

    case avatar, status, phone
    case socialNetwork, exit

    // MARK: - Internal Properties

    var title: String {
        let strings = R.string.localizable.self
        switch self {
        case .status:
            return strings.profileDetailStatusLabel()
        case .phone:
            return strings.profileDetailPhoneLabel()
        default:
            return ""
        }
    }
}
