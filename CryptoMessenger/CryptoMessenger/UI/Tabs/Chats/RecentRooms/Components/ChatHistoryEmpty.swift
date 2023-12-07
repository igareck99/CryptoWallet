import SwiftUI

// MARK: - ChatHistoryEmpty

enum ChatHistoryEmpty {

    case noData
    case emptySearch
    case noChats

    var image: Image {
        switch self {
        case .noData:
           return R.image.chatHistory.nodata.image
        case .emptySearch:
            return R.image.chatHistory.emptyState.image
        case .noChats:
            return R.image.chatHistory.noChats.image
        }
    }

    var title: String {
        switch self {
        case .noData:
            return R.string.localizable.chatHistoryNoResult()
        case .emptySearch:
            return R.string.localizable.chatHistorySearchEmpty()
        case .noChats:
            return R.string.localizable.chatHistoryNoMessages()
        }
    }

    var description: String {
        switch self {
        case .noData:
            return R.string.localizable.chatHistoryNothingFind()
        case .emptySearch:
            return R.string.localizable.chatHistoryEnterData()
        case .noChats:
            return R.string.localizable.chatHistoryNoActiveChats()
        }
    }
}
