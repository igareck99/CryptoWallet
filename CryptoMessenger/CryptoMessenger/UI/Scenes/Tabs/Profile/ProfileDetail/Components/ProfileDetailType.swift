import Foundation

// MARK: - ProfileDetailType

enum ProfileDetailType: CaseIterable {

    // MARK: - Types

    case avatar, status, info, name, phone
    case socialNetwork, exit, delete

    // MARK: - Internal Properties

    var title: String {
        let strings = R.string.localizable.self
        switch self {
        case .status:
            return strings.profileDetailStatusLabel()
        case .info:
            return strings.profileDetailInfoLabel()
        case .name:
            return strings.profileDetailNameLabel()
        case .phone:
            return strings.profileDetailPhoneLabel()
        default:
            return ""
        }
    }
}
