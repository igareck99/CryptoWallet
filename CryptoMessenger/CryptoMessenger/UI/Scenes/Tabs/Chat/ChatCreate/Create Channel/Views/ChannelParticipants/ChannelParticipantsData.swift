import Foundation
import SwiftUI

// MARK: - ChannelParticipantsData

struct ChannelParticipantsData: Hashable {

    // MARK: - Internal Properties

    let name: String
    let matrixId: String
    var role: ChannelRole
}

// MARK: - ChannelRole

enum ChannelRole: String {

    case owner = "Владелец"
    case admin = "Администратор"
    case user = "Пользователь"
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
