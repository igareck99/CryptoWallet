import SwiftUI

// MARK: - AttachAction

enum AttachAction: CaseIterable, Identifiable {
    static var allCases: [AttachAction] = [
        .media,
        .document,
        .location,
        .contact,
        .moneyTransfer(receiverWallet: .mock)
    ]

    // MARK: - Types

    case media
    case document
    case location
    case contact
    case moneyTransfer(receiverWallet: UserWallletData)

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .media:
            return "Фото/ Видео"
        case .document:
            return "Документ"
        case .location:
            return "Геопозиция"
        case .contact:
            return "Контакт"
        case .moneyTransfer:
            return "Перевод средств"
        }
    }

    var image: Image {
        switch self {
        case .media:
            return R.image.chat.action.media.image
        case .document:
            return R.image.chat.action.document.image
        case .location:
            return R.image.chat.action.location.image
        case .contact:
            return R.image.chat.action.contact.image
        case .moneyTransfer:
            return R.image.chat.action.transfer.image
        }
    }
}


// MARK: - ActionItem

struct ActionItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let action: AttachAction
}
