import Foundation
import SwiftUI

// MARK: - ChannelParticipantsData

struct ChannelParticipantsData: Hashable {

    // MARK: - Internal Properties

    let name: String
    let matrixId: String
    var role: ChannelRole
    // Contact
    var avatar: URL?
    var status: String = ""
    var phone = ""
    var isAdmin = false
}

// MARK: - ChannelRole

enum ChannelRole: Int {

    case owner
    case admin
    case user
    
    var text: String {
        switch self {
        case .owner: return "Владелец"
        case .admin: return "Администратор"
        case .user: return "Пользователь"
        default: return ""
        }
    }
    
    var powerLevel: Int {
        switch self {
        case .owner: return 100
        case .admin: return 50
        case .user: return 0
        default: return 0
        }
    }
}

// MARK: - ChannelUserMenuActions

enum ChannelUserMenuActions: String {

//    case open = R.string.localizable.channelSettingsOpenProfile()
//    case change = R.string.localizable.channelSettingsChangeRole()
//    case delete = R.string.localizable.channelSettingsDeleteFromChannel()
    case open = "Открыть профиль"
    case change = "Изменить роль"
    case delete = "Удалить из канала"
}

// MARK: - ChannelUserMenuActions

struct ChannelUserMenuAction: Hashable {

    let image: UIImage
    let action: ChannelUserMenuActions
}
