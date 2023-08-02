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
    
    var color: Color {
        switch self {
        case .pin, .watchProfile:
            return Color.chineseBlack04
        case .removeChat:
            return Color.spanishCrimson
        }
    }
    
    func text(_ isPinned: Bool) -> String {
        switch self {
        case .pin:
            if isPinned {
                return R.string.localizable.chatHistoryPin()
            } else {
                return "Открепить"
            }
        case .watchProfile:
            return R.string.localizable.chatHistoryWatchProfile()
        case .removeChat:
            return R.string.localizable.chatHistoryRemove()
        }
    }

    static func getAvailableActions(_ isWatchProfile: Bool,
                                    _ isLeaveChat: Bool) -> [ChatActions] {
        var result = [ChatActions.pin]
        if isWatchProfile {
            result.append(ChatActions.watchProfile)
        }
        if isLeaveChat {
            result.append(ChatActions.removeChat)
        }
        return result
    }
}
