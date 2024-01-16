import SwiftUI

// MARK: - ChatActions

enum ChatActions: CaseIterable {

    // MARK: - Cases

    case pin
    case watchProfile
    case removeChat
    
    func image(_ isPinned: Bool) -> Image {
        switch self {
        case .pin:
            if isPinned {
                return R.image.chatHistory.unpin.image
            }
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
            return .chineseBlack
        case .removeChat:
            return .spanishCrimson
        }
    }

    func text(_ isPinned: Bool) -> String {
        switch self {
        case .pin:
            if isPinned {
                return R.string.localizable.chatHistoryUnPin()
            } else {
                return R.string.localizable.chatHistoryPin()
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

    static func getSheetHeight(_ isWatchProfile: Bool,
                               _ isLeaveChat: Bool) -> CGFloat {
        var result = [ChatActions.pin]
        if isWatchProfile {
            result.append(ChatActions.watchProfile)
        }
        if isLeaveChat {
            result.append(ChatActions.removeChat)
        }
        return CGFloat(177 - (3 - result.count) * 52)
    }
}
