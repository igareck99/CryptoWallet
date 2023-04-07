import SwiftUI

// MARK: - CreateAction

enum CreateAction: CaseIterable, Identifiable {

    // MARK: - Types

    case newContact, groupChat, createChannel

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var text: Text {
        switch self {
        case .createChannel:
            return Text(R.string.localizable.createActionCreateChannel())
        case .newContact:
            return Text(R.string.localizable.createActionNewContact())
        case .groupChat:
            return Text(R.string.localizable.createActionGroupChat())
        }
    }

    var color: Palette { .black() }

    var image: Image {
        switch self {
        case .createChannel:
            return R.image.chat.group.channel.image
        case .newContact:
            return R.image.chat.group.contact.image
        case .groupChat:
            return R.image.chat.group.group.image
        }
    }
}
