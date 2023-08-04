import SwiftUI

// MARK: - ChatActions

enum ChatActions: CaseIterable {

    // MARK: - Cases

    case pin
    case watchProfile
    case removeChat

    var image: Image {
        switch self {
        case .pin:
            return R.image.chatHistory.pin.image
        case .watchProfile:
            return R.image.chatHistory.person.image
        case .removeChat:
            return R.image.chatHistory.trash.image
        }
    }
    
    var text: String {
        switch self {
        case .pin:
            return R.string.localizable.chatHistoryPin()
        case .watchProfile:
            return R.string.localizable.chatHistoryWatchProfile()
        case .removeChat:
            return R.string.localizable.chatHistoryRemove()
        }
    }
    
    var color: Color {
        switch self {
        case .pin, .watchProfile:
            return Color.chineseBlack04
        case .removeChat:
            return Color.spanishCrimson
        }
    }
    
}
